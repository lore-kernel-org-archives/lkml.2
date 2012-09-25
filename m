Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2IYGrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:47:32 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:42634 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab2IYGrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:47:31 -0400
Date: Tue, 25 Sep 2012 08:47:28 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 22/30] perf tools: bfd.h/libbfd detection fails with
 recent binutils
Message-ID: <20120925064728.GA241@x4>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
 <1348502384-14442-23-git-send-email-acme@infradead.org>
 <201209241958.33449.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209241958.33449.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.09.24 at 19:58 -0400, Mike Frysinger wrote:
> On Monday 24 September 2012 11:59:36 Arnaldo Carvalho de Melo wrote:
> > --- a/tools/perf/Makefile
> > +++ b/tools/perf/Makefile
> >
> > -		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
> > +		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -
> 
> in this case, if you were to expand PACKAGE, you'd get back the symbol perf 
> (which most likely will be an error, but maybe it won't).  i think this should 
> be instead:
> 	-DPACKAGE='"perf"'
> 
> > --- a/tools/perf/util/symbol.h
> > +++ b/tools/perf/util/symbol.h
> >
> > +#define PACKAGE 'perf'
> 
> this isn't valid C anywhere.  pretty sure this should be:
> 	#define PACKAGE "perf"

The only thing that's really important is that PACKAGE isn't NULL,
because it's just a workaround for this brilliant gem from bfd.h:

  35 /* PR 14072: Ensure that config.h is included first.  */
  36 #if !defined PACKAGE && !defined PACKAGE_VERSION
  37 #error config.h must be included before this header
  38 #endif

So if you feel strongly about it, feel free to post a patch that just
sets PACKAGE to 1. This would avoid all possible ambiguity.

-- 
Markus
