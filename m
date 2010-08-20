Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab0HTRev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:34:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab0HTRes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:34:48 -0400
Date: Fri, 20 Aug 2010 14:34:41 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 11/35] Add helper functions for time computation
Message-ID: <20100820173440.GF2937@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-12-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282291669-25709-12-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:07:25PM -1000, Zachary Amsden wrote:
> Add a helper function to compute the kernel time and convert nanoseconds
> back to CPU specific cycles.  Note that these must not be called in preemptible
> context, as that would mean the kernel could enter software suspend state,
> which would cause non-atomic operation.
> 
> Also, convert the KVM_SET_CLOCK / KVM_GET_CLOCK ioctls to use the kernel
> time helper, these should be bootbased as well.
This is one of the things I believe should be applied right now.
Maybe we want a cut version of this patch, that exposes this API while
adjusting KVM_SET_CLOCK / KVM_GET_CLOCK to get in early rather than late?
