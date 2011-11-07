Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab1KGPzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:55:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab1KGPzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:55:10 -0500
Date: Mon, 7 Nov 2011 17:54:53 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 7/9] KVM: Expose the architectural performance
 monitoring CPUID leaf
Message-ID: <20111107155453.GJ8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-8-git-send-email-gleb@redhat.com>
 <1320674987.18053.39.camel@twins>
 <20111107154132.GH8670@redhat.com>
 <1320680757.17809.2.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320680757.17809.2.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 04:45:57PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-07 at 17:41 +0200, Gleb Natapov wrote:
> > > > +               entry->eax = min(cap.version, 2)
> > > > +                       | (cap.num_counters_gp << 8)
> > > > +                       | (cap.bit_width_gp << 16)
> > > > +                       | (cap.events_mask_len << 24); 
> 
> 
> > Do you mean by doing cpuid here directly instead of checking perf
> > capability?
> 
> No I meant something like:
>         
>         union cpuid10_eax eax;
>         
>         eax.version	 = min(cap.version, 2);
>         eax.bit_width	 = cap.bit_width;
>         eax.num_counters = cap.num_counters;
>         eax.mask_length	 = cap.mask_length;
>         
>         entry->eax = eax.full;
>         
Ah, yes. Will do that.

--
			Gleb.
