Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab1KGOMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:12:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43661 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1KGOMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:12:12 -0500
Subject: Re: [PATCHv2 7/9] KVM: Expose the architectural performance
 monitoring CPUID leaf
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Date: Mon, 07 Nov 2011 15:09:46 +0100
In-Reply-To: <1320323618-10375-8-git-send-email-gleb@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-8-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320674987.18053.39.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> +       case 0xa: { /* Architectural Performance Monitoring */
> +               struct x86_pmu_capability cap;
> +
> +               perf_get_x86_pmu_capability(&cap);
> +
> +               /*
> +                * Only support guest architectural pmu on a host
> +                * with architectural pmu.
> +                */
> +               if (!cap.version)
> +                       memset(&cap, 0, sizeof(cap));
> +
> +               entry->eax = min(cap.version, 2)
> +                       | (cap.num_counters_gp << 8)
> +                       | (cap.bit_width_gp << 16)
> +                       | (cap.events_mask_len << 24);
> +               entry->ebx = cap.events_mask;
> +               entry->ecx = 0;
> +               entry->edx = cap.num_counters_fixed
> +                       | (cap.bit_width_fixed << 5);
> +               break;
> +       } 

would it make sense to use the cpuid10_e[ad]x unions to fill out that
data?
