Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0HTRGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:06:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0HTRGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:06:53 -0400
Date: Fri, 20 Aug 2010 14:06:43 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM timekeeping 03/35] Move TSC offset writes to common code
Message-ID: <20100820170643.GB2937@mothafucka.localdomain>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
 <1282291669-25709-4-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282291669-25709-4-git-send-email-zamsden@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 10:07:17PM -1000, Zachary Amsden wrote:
> Also, ensure that the storing of the offset and the reading of the TSC
> are never preempted by taking a spinlock.  While the lock is overkill
> now, it is useful later in this patch series.
> 
> +	spinlock_t tsc_write_lock;
Forgive my utter ignorance, specially if it is to become
obvious in a latter patch: This is a vcpu-local operation,
uses rdtscl, so pcpu-local too, and we don't expect
multiple writers to it at the same time.

Why do we need this lock?

