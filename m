Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0DSK7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:59:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49385 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab0DSK7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:59:14 -0400
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
In-Reply-To: <4BCC3617.6050106@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
	 <1271356648-5108-2-git-send-email-glommer@redhat.com>
	 <4BCA026D.3070309@redhat.com>  <1271673975.1674.763.camel@laptop>
	 <1271674154.1674.771.camel@laptop>  <4BCC3617.6050106@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 12:59:05 +0200
Message-ID: <1271674745.1674.802.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 13:53 +0300, Avi Kivity wrote:
> On 04/19/2010 01:49 PM, Peter Zijlstra wrote:
> >
> >> Right, so on x86 we have:
> >>
> >> X86_FEATURE_CONSTANT_TSC, which only states that TSC is frequency
> >> independent, not that it doesn't stop in C states and similar fun stuff.
> >>
> >> X86_FEATURE_TSC_RELIABLE, which IIRC should indicate the TSC is constant
> >> and synced between cores.
> >>      
> > Fun, we also have:
> >
> > X86_FEATURE_NONSTOP_TSC, which states the thing doesn't stop in C
> > states.
> >    
> 
> All of them? I though tsc stops in some mwait deep REM sleep thing.

The idea is that TSC will not stop ever (except s2r like stuff), not
sure about the actual implementation of the NONSTOP_TSC bit though.

> So what do we need?  test for both TSC_RELIABLE and NONSTOP_TSC?  IMO 
> TSC_RELIABLE should imply NONSTOP_TSC.

Yeah, I think RELIABLE does imply NONSTOP and CONSTANT, but NONSTOP &&
CONSTANT does not make RELIABLE.



