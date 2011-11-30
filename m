Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1K3PBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 10:01:18 -0500
Received: from postman.teamix.net ([194.150.191.120]:43082 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755653Ab1K3PBN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 10:01:13 -0500
Date: Wed, 30 Nov 2011 16:01:11 +0100 (CET)
From: Martin Steigerwald <ms@teamix.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/1] Mention that I/O priorities also work on direct writes.
Message-ID: <aee25f9f-6739-40ca-838b-10b497797365@zimbra>
In-Reply-To: <201111281619.12924.ms@teamix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Originating-IP: [172.21.123.1]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens!

Did you notice the three patches I send?

Thanks,
Martin

----- Ursprüngliche Mail -----
> Am Montag, 28. November 2011 schrieb Jens Axboe:
> > On 2011-11-28 15:42, Martin Steigerwald wrote:
> > > Hi jens und Vivek,
> > > 
> > > Vivek, I cc'd you, cause you wrote the new cfq-iosched.txt.
> > > 
> > > 
> > > In trying to understand how I/O priorities actually really work,
> > > I tried
> > > to dd with
> > > 
> > > rm nullen-id ; sync ; /usr/bin/time ionice -c3 dd if=/dev/zero
> > > of=nullen-id count=500 bs=1M conv=fsync
> > > 
> > > versus
> > > 
> > > rm nullen-rl; sync ; /usr/bin/time ionice -c1 -n0 dd if=/dev/zero
> > > of=nullen-rl count=500 bs=1M conv=fsync
> > > 
> > > concurrently. No differences. At first I was puzzled, then I
> > > thought
> > > maybe direct I/O makes a difference. So I tried with
> > > oflag=direct.
> > > 
> > > And it does.
> > > 
> > > Then I actually read the documentation block/ioprio.txt (3.1
> > > here):
> > >> With the introduction of cfq v3 (aka cfq-ts or time sliced cfq),
> > >> basic
> > >> io priorities are supported for reads on files.  This enables
> > >> users to
> > >> io nice processes or process groups, similar to what has been
> > >> possible
> > >> with cpu scheduling for ages.  This document mainly details the
> > >> current
> > >> possibilities with cfq; other io schedulers do not support io
> > >> priorities
> > >> thus far.
> > > 
> > > According to it I/O priorities will even only work on reads. Is
> > > that
> > > correct? I mean they do work on reads, I tested it, but *only* on
> > > reads?
> > > 
> > > From what I see here, it also works for direct I/O write requests
> > > 
> > > So from what I conclude is that CFQ I/O priorities work for all
> > > requests
> > > that are issued via synchronous system calls, but not for those
> > > issued
> > > via asynchronous calls, i. e. everything that goes through the
> > > pagecache.
> > > 
> > > Is that correct?
> > 
> > Priorities work for reads AND direct writes. In other words, it
> > does not
> > work for buffered writes.
> > 
> > > Vivek, one thing on cfq-iosched.txt: Could slice_idle=0 make
> > > sense on
> > > SSDs?  Later on you write that there are some SSD optimizations
> > > in
> > > place that cut down idling already.
> > 
> > It will have a functional difference even on SSDs, depending on
> > your
> > workload, even if the scope of idling is smaller on an SSD.
> 
> From 5414ce9fd8c384a3a25a478490a022539694e4e0 Mon Sep 17 00:00:00
> 2001
> From: Martin Steigerwald <ms@teamix.de>
> Date: Mon, 28 Nov 2011 16:10:32 +0100
> Subject: [PATCH 1/3] Mention that I/O priorities also work on direct
> writes.
> 
> ---
>  Documentation/block/ioprio.txt |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/block/ioprio.txt
> b/Documentation/block/ioprio.txt
> index 8ed8c59..a555c59 100644
> --- a/Documentation/block/ioprio.txt
> +++ b/Documentation/block/ioprio.txt
> @@ -6,10 +6,11 @@ Intro
>  -----
>  
>  With the introduction of cfq v3 (aka cfq-ts or time sliced cfq),
>  basic io
> -priorities are supported for reads on files.  This enables users to
> io nice
> -processes or process groups, similar to what has been possible with
> cpu
> -scheduling for ages.  This document mainly details the current
> possibilities
> -with cfq; other io schedulers do not support io priorities thus far.
> +priorities are supported for reads and direct, not buffered, writes
> on files
> +This enables users to io nice processes or process groups, similar
> to what
> +has been possible with cpu scheduling for ages. This document mainly
> details
> +the current possibilities with cfq; other io schedulers do not
> support io
> +priorities thus far.
>  
>  Scheduling classes
>  ------------------
> --
> 1.7.7.3
> 
> Thanks,
> --
> Martin Steigerwald - teamix GmbH - http://www.teamix.de
> gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Martin Steigerwald
Trainer / Consultant

teamix GmbH
Solide IT-Infrastruktur
Südwestpark 35
90449 Nürnberg

fon:   +49 (911) 30999- 0
fax:   +49 (911) 30999-99
mail:  ms@teamix.de
web:   http://www.teamix.de
vcf:   http://www.teamix.de/vcf/ms.vcf
gpg:   19E3 8D42 896F D004 08AC
       A0CA 1E10 C593 0399 AE90

Amtsgericht Nürnberg, HRB 18320
Geschäftsführer: Oliver Kügow, Richard Müller
