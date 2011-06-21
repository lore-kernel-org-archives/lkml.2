Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab1FURy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:54:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65486 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab1FURyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=adi3d1K9l6rPTyBSTpNTeKh+vp0LT1/4ogNSr73b+0vYRy3D+81l/KlalY/p/Ie0Lg
         ZyaUoHV63htIgA+eKMO5BEiQyX3E9KNac/HaAsHjZX5FitzlX1h9IZulzlbbhGuXVAjq
         /+NSxyjS5ormIZLMZFLRAoGyMa4si6TnMweRY=
Date: Tue, 21 Jun 2011 21:54:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vweaver1@eecs.utk.edu>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] perf, x86: Add PERF_COUNT_HW_NMI_WATCHDOG event v2
Message-ID: <20110621175421.GF21641@sun>
References: <4DB989B5.1030703@openvz.org>
 <20110621152301.GA5155@redhat.com>
 <BANLkTi=zPq81nScodFcPxcLSrTGPNA1HWA@mail.gmail.com>
 <1308671933.26237.183.camel@twins>
 <BANLkTim-2p1DgV1XD_J2vH514aL_KuFaEQ@mail.gmail.com>
 <BANLkTikxWV8tjXrZnOrNnsw+nmsjGaxWbw@mail.gmail.com>
 <20110621164820.GC21641@sun>
 <BANLkTink5nOTqvqQYr4kx0fnBoOpoq7CiQ@mail.gmail.com>
 <20110621172319.GE21641@sun>
 <BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikBsfcFfnmgdVQem15P9f2ooQBzeA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 07:26:16PM +0200, Stephane Eranian wrote:
...
> >
> >  It doesn't change things much. Of course I can put some specifics into
> > .config but where is the guarantee some new generic event would not ever
> > intersect with it. I know (for example) we could reserve -1ULL for this
> > event but again where is the guarantee that it will never ever be used
> > system wide in future for some different event?
> >
> I am not talking about a new generic PMU event. I am talking about
> you hardcoding a raw event in the callback: type = PERF_TYPE_RAW,
> config=0x003c.
> 

watchdog.c is system-wide and even if it's not used by archs other
than x86 doesn't mean it'll not in future ;) So we could encode
this watchdog event as you mention (and I would check for this
values and map it internally to bits I need, this btw will require me
to check if this bits do not intersect with some already valid bits
combination but it's a different problem) but than we _must_ be sure it
never bring problems as new arch or consumer appear. So, no, I don't
like this approach, it's fragile. But gimme some time -- I'll re-check
all bits, probably there is some workaround.

	Cyrill
