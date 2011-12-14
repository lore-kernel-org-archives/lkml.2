Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab1LNOuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:50:46 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60415 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab1LNOuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:50:44 -0500
Message-ID: <4EE8B78F.9090104@us.ibm.com>
Date: Wed, 14 Dec 2011 08:49:51 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Eric B Munson <emunson@mgebm.net>,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        ryanh@linux.vnet.ibm.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped
 by host
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>	<4EDF7B0D.4060001@redhat.com> <20111214121622.GB18317@amt.cnet> <4EE8B53C.6070502@redhat.com>
In-Reply-To: <4EE8B53C.6070502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11121414-5930-0000-0000-0000032AD8D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 08:39 AM, Avi Kivity wrote:
> On 12/14/2011 02:16 PM, Marcelo Tosatti wrote:
>>> Having this controlled from userspace means it doesn't work for SIGSTOP
>>> or for long scheduling delays.  What about doing this automatically
>>> based on preempt notifiers?
>>
>> Long scheduling delays should be considered hangups from the guest
>> perspective.
>
> Why?  To the guest it looks like slow hardware, but it will interpret it
> as a softlockup.
>
>> About SIGSTOP, that is a corner case. Unsure if its even properly supported
>> by QEMU.
>
> It works from my experience.

We don't adjust vm_clock's offset on SIGSTOP/SIGCONT so while it may appear to 
work okay, QEMU isn't exhibiting the behavior it is supposed to.

Regards,

Anthony Liguori

>

