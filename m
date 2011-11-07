Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1KGPrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:47:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46159 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1KGPrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:47:03 -0500
Subject: Re: [PATCHv2 7/9] KVM: Expose the architectural performance
 monitoring CPUID leaf
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Date: Mon, 07 Nov 2011 16:45:57 +0100
In-Reply-To: <20111107154132.GH8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
	 <1320323618-10375-8-git-send-email-gleb@redhat.com>
	 <1320674987.18053.39.camel@twins> <20111107154132.GH8670@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320680757.17809.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 17:41 +0200, Gleb Natapov wrote:
> > > +               entry->eax = min(cap.version, 2)
> > > +                       | (cap.num_counters_gp << 8)
> > > +                       | (cap.bit_width_gp << 16)
> > > +                       | (cap.events_mask_len << 24); 


> Do you mean by doing cpuid here directly instead of checking perf
> capability?

No I meant something like:
        
        union cpuid10_eax eax;
        
        eax.version	 = min(cap.version, 2);
        eax.bit_width	 = cap.bit_width;
        eax.num_counters = cap.num_counters;
        eax.mask_length	 = cap.mask_length;
        
        entry->eax = eax.full;
        

