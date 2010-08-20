Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab0HTRJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:09:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0HTRI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:08:57 -0400
Date: Fri, 20 Aug 2010 14:08:49 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 05/35] Move TSC reset out of vmcb_init
Message-ID: <20100820170849.GC2937@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-6-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282291669-25709-6-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:07:19PM -1000, Zachary Amsden wrote:
> The VMCB is reset whenever we receive a startup IPI, so Linux is setting
> TSC back to zero happens very late in the boot process and destabilizing
> the TSC.  Instead, just set TSC to zero once at VCPU creation time.
> 
> Why the separate patch?  So git-bisect is your friend.
> 
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Shouldn't we set for whatever value the BSP already has, and then the BSP to
zero? Since vcpus are initialized at different times, this pretty much
guarantees that the guest will have desynchronized tsc at all cases
(not that if it was better before...)
