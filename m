Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1EQTla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 15:41:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56770 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932169Ab1EQTl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 15:41:27 -0400
Date: Tue, 17 May 2011 21:41:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to
 guests
Message-ID: <20110517194117.GA26184@elte.hu>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
 <1305129333-7456-6-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305129333-7456-6-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Caveats:
> - counters that have PMI (interrupt) enabled stop counting after the
>   interrupt is signalled.  This is because we need one-shot samples
>   that keep counting, which perf doesn't support yet

Hm, do you need more than perf_event::event_limit, or something special?

> - some combinations of INV and CMASK are not supported

Could you please describe this better, where does this limit come from?
If perf then this needs fixing.

> - counters keep on counting in the host as well as the guest

I suspect fixing this either needs a hw filter feature, or the ability to 
disable/enable these events across VM exits/entries.

I would imagine the disable/enable to be rather expensive so hw help would be 
preferred ...

I didnt see anything objectionable in your patches, but i'd like to have 
Peter's Acked-by as well before we go forward. I think that in the long run 
having a virtio-perf gateway would allow us a lot more tricks than just 
arch-perfmon emulation:

 - we could do things like propagate guest side traces over to the host

 - we could control from the host which events we measure on the guest side

 - etc.

How would you like to handle the flow of patches - should we merge #1,#2,#3 in 
perf/core and you'd then merge #4,#5 via the KVM tree once the first bits hit 
upstream?

We could also set up a separate branch for these three commits, which you could 
pull - this would allow all this to still hit .40.

Thanks,

	Ingo
