Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1AFKmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:42:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:37410 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab1AFKmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:42:47 -0500
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1294308645-31113-2-git-send-email-zamsden@redhat.com>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <9EEA19E7-668A-4CD0-B006-6B494D9FD242@suse.de>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8C148)
From: Alexander Graf <agraf@suse.de>
Subject: Re: [KVM TSC trapping / migration 1/2] Add TSC trapping for SVM and VMX
Date: Thu, 6 Jan 2011 11:41:37 +0100
To: Zachary Amsden <zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 06.01.2011 um 11:10 schrieb Zachary Amsden <zamsden@redhat.com>:

> Reasons to trap the TSC are numerous, but we want to avoid it as much
> as possible for performance reasons.
> 
> We provide two conservative modes via modules parameters and userspace
> hinting.  First, the module can be loaded with "tsc_auto=1" as a module
> parameter, which turns on conservative TSC trapping only when it is
> required (when unstable TSC or faster KHZ CPU is detected).
> 
> For userspace hinting, we enable trapping only if necessary.  Userspace
> can hint that a VM needs a fixed frequency TSC, and also that SMP
> stability will be required.  In that case, we conservatively turn on
> trapping when it is needed.  In addition, users may now specify the
> desired TSC rate at which to run.  If this rate differs significantly
> from the host rate, trapping will be enabled.
> 
> There is also an override control to allow TSC trapping to be turned on
> or off unconditionally for testing.
> 
> We indicate to pvclock users that the TSC is being trapped, to allow
> avoiding overhead and directly using RDTSCP (only for SVM).  This
> optimization is not yet implemented.

When migrating, the implementation could switch from non-trapped to trapped, making it less attractive. The guest however does not get notified about this change. Same for the other way around.

Would it make sense to add a kvmclock interrupt to notify the guest of such a change?


Alex

> 
