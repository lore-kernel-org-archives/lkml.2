Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab2LETMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:12:17 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54581 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2LETMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:12:16 -0500
Date: Wed, 5 Dec 2012 16:12:09 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf hists: Link hist entries before inserting to an
 output tree
Message-ID: <20121205191209.GE6629@ghostprotocols.net>
References: <1354690603-31364-1-git-send-email-namhyung@kernel.org>
 <1354690603-31364-3-git-send-email-namhyung@kernel.org>
 <20121205190646.GB1037@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205190646.GB1037@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 05, 2012 at 08:06:46PM +0100, Jiri Olsa escreveu:
> On Wed, Dec 05, 2012 at 03:56:42PM +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > @@ -481,6 +459,11 @@ static void hists__process(struct hists *old, struct hists *new)
> >  	else
> >  		hists__link(new, old);
> >  
> > +	hists__output_resort(new);
> > +
> > +	if (show_displacement)
> > +		hists__compute_position(new);
> > +
> 
> Computing the position after hists__link screws up the position data,
> because we likely have new entries in.
> 
> However, I wonder if anyone is actualy using displacement info..?

IIRC that was used long ago in the first version of 'perf diff', that
is not the default, probably we can just ditch it to simplify things,
can you check?

- Arnaldo
