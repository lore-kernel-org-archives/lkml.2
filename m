Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab2IJOpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:45:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:44046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2IJOpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:45:14 -0400
Message-ID: <1347288296.2124.12.camel@twins>
Subject: Re: [PATCH v2 03/12] perf tools: include __WORDSIZE definition
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, mingo@redhat.com,
        acme@ghostprotocols.net, rostedt@goodmis.org, paulus@samba.org,
        dsahern@gmail.com, namhyung.kim@lge.com, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Date: Mon, 10 Sep 2012 16:44:56 +0200
In-Reply-To: <CANg8OW+iuqnc-_daWDSXymYNKnr0YEoa_3310YvYJAUF_vCTnQ@mail.gmail.com>
References: <1347065004-15306-1-git-send-email-irina.tirdea@intel.com>
	 <1347065004-15306-4-git-send-email-irina.tirdea@intel.com>
	 <CAOJsxLHCavYZQCOZP0nw0ig9uFx0wbR5UP23zKa0gXvmpFvNDg@mail.gmail.com>
	 <CANg8OW+iuqnc-_daWDSXymYNKnr0YEoa_3310YvYJAUF_vCTnQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-09-09 at 01:19 +0300, Irina Tirdea wrote:
> >> +#ifndef __WORDSIZE
> >> +#if defined(__x86_64__)
> >> +# define __WORDSIZE 64
> >> +#endif
> >> +#if defined(__i386__) || defined(__arm__)
> >> +# define __WORDSIZE 32
> >> +#endif
> >> +#endif
> >
> > Why not use "sizeof(unsigned long) * 8" ?
> 
> I tried to do it this, but the compilation crashes because this value
> is tested in an #if:
> 
> target  C: libperf <= tools/perf/util/annotate.c
> In file included from tools/perf/util/include/linux/bitmap.h:5:0,
>                  from tools/perf/util/header.h:10,
>                  from tools/perf/util/session.h:6,
>                  from tools/perf/util/build-id.h:4,
>                  from tools/perf/util/annotate.c:11:
> tools/perf/util/include/linux/bitops.h: In function '__ffs':
> tools/perf/util/include/linux/bitops.h:62:5: warning: "sizeof" is not
> defined [-Wundef]
> tools/perf/util/include/linux/bitops.h:62:5: error: missing binary
> operator before token "("

Use either: __SIZEOF_LONG__ (8) or __LP64__ (1) 
