Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0DSKtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:49:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0DSKtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:49:18 -0400
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
In-Reply-To: <1271673975.1674.763.camel@laptop>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
	 <1271356648-5108-2-git-send-email-glommer@redhat.com>
	 <4BCA026D.3070309@redhat.com>  <1271673975.1674.763.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 12:49:14 +0200
Message-ID: <1271674154.1674.771.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 12:46 +0200, Peter Zijlstra wrote:
> On Sat, 2010-04-17 at 21:48 +0300, Avi Kivity wrote:
> > > After this patch is applied, I don't see a single warp in time during 5 days
> > > of execution, in any of the machines I saw them before.
> > >
> > >    
> > 
> > Please define a cpuid bit that makes this optional.  When we eventually 
> > enable it in the future, it will allow a wider range of guests to enjoy it.
> 
> Right, so on x86 we have:
> 
> X86_FEATURE_CONSTANT_TSC, which only states that TSC is frequency
> independent, not that it doesn't stop in C states and similar fun stuff.
> 
> X86_FEATURE_TSC_RELIABLE, which IIRC should indicate the TSC is constant
> and synced between cores.

Fun, we also have:

X86_FEATURE_NONSTOP_TSC, which states the thing doesn't stop in C
states.

