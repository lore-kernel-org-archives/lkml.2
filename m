Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab2A3RMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:12:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab2A3RMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:12:05 -0500
Message-ID: <4F26CF3D.4070001@redhat.com>
Date: Mon, 30 Jan 2012 19:11:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 V10] Add ioctl for KVMCLOCK_GUEST_STOPPED
References: <1326825641-15765-1-git-send-email-emunson@mgebm.net> <1326825641-15765-4-git-send-email-emunson@mgebm.net> <4F26B220.9050101@redhat.com> <4F26C2EC.5070303@siemens.com>
In-Reply-To: <4F26C2EC.5070303@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 06:18 PM, Jan Kiszka wrote:
> > 
> > This looks racy.  The vcpu can remove its kvmclock concurrently with
> > this access, and src will be NULL.
>
> There is no race here (src is member of the vcpu), but arch.time might
> have become invalid. KVM_REQ_CLOCK_UPDATE instead of mark_page_dirty
> would indeed be the way to go. Trivial solution, I would say.
>
> However, the concept of "guest stopped" has VM, not VCPU scope. 

We're not stopping the guest here, just setting a flag in kvmclock,
which certainly is a per-vcpu thing.

> That
> makes the call more appropriate as a VM ioctl. If that thing should
> really become per-vcpu, at least call it KVMCLOCK_VCPU_STOPPED.
>

All current ioctls start with KVM_. Maybe KVM_KVMCLOCK_CTRL?

-- 
error compiling committee.c: too many arguments to function

