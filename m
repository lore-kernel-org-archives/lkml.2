Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1KQJaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:30:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54728 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab1KQJaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:30:03 -0500
Subject: Re: [PATCHv3 06/10] x86, perf: disable non available architectural
 events.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        mtosatti@redhat.com, mingo@elte.hu, acme@ghostprotocols.net
Date: Thu, 17 Nov 2011 10:29:34 +0100
In-Reply-To: <1320929850-10480-7-git-send-email-gleb@redhat.com>
References: <1320929850-10480-1-git-send-email-gleb@redhat.com>
	 <1320929850-10480-7-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321522174.27735.26.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 14:57 +0200, Gleb Natapov wrote:
> +
> +       /* disable event that reported as not presend by cpuid */
> +       for_each_set_bit(bit, x86_pmu.events_mask,
> +                       min(x86_pmu.events_mask_len, x86_pmu.max_events))
> +               intel_perfmon_event_map[intel_event_id_to_hw_id[bit]] = 0;

I think that should read:

        for_each_set_bit(bit, x86_pmu.events_mask, ARRAY_SIZE(intel_event_id_to_hw_id))
                intel_perfmon_event_map[intel_event_id_to_hw_id[bit]] = 0;

There is no guarantee x86_pmu.max_events has any relation to the size of
intel_event_id_to_hw_id.

Changed it for you.
