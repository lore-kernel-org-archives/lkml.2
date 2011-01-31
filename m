Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1AaLGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:06:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:47918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab1AaLGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:06:19 -0500
Subject: Re: [PATCH v2 2/6] KVM-HV: KVM Steal time implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, tglx <tglx@linutronix.de>
In-Reply-To: <1296244340-15173-3-git-send-email-glommer@redhat.com>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-3-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 12:07:11 +0100
Message-ID: <1296472031.15234.367.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 14:52 -0500, Glauber Costa wrote:
> +               u64 to = (get_kernel_ns() - vcpu->arch.this_time_out);
> +               /*
> +                * using nanoseconds introduces noise, which accumulates easily
> +                * leading to big steal time values. We want, however, to keep the
> +                * interface nanosecond-based for future-proofness.
> +                */
> +               to /= NSEC_PER_USEC;
> +               to *= NSEC_PER_USEC; 

This just doesn't make any sense at all, you use the most expensive and
accurate kernel interface to get ns resolution timestamps (ktime_get),
and then you truncate the stuff to usec for some totally weird and
unexplained reason.

If ktime_get is wrong all our time-keeping is out the window.



