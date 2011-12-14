Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1LNOkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:40:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1LNOkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:40:13 -0500
Message-ID: <4EE8B53C.6070502@redhat.com>
Date: Wed, 14 Dec 2011 16:39:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped
 by host
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net> <4EDF7B0D.4060001@redhat.com> <20111214121622.GB18317@amt.cnet>
In-Reply-To: <20111214121622.GB18317@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 02:16 PM, Marcelo Tosatti wrote:
> > Having this controlled from userspace means it doesn't work for SIGSTOP
> > or for long scheduling delays.  What about doing this automatically
> > based on preempt notifiers?
>
> Long scheduling delays should be considered hangups from the guest
> perspective.

Why?  To the guest it looks like slow hardware, but it will interpret it
as a softlockup.

> About SIGSTOP, that is a corner case. Unsure if its even properly supported 
> by QEMU.

It works from my experience.

-- 
error compiling committee.c: too many arguments to function

