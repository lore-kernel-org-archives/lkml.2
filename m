Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2BFTqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:46:30 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:14627
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751718Ab2BFTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:46:29 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4F302E0D.20302@freescale.com>
Date: Mon, 6 Feb 2012 13:46:21 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Eric Northup <digitaleric@google.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com> <4F2C6517.3040203@codemonkey.ws>
In-Reply-To: <4F2C6517.3040203@codemonkey.ws>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 04:52 PM, Anthony Liguori wrote:
> On 02/03/2012 12:07 PM, Eric Northup wrote:
>> On Thu, Feb 2, 2012 at 8:09 AM, Avi Kivity<avi@redhat.com>  wrote:
>> [...]
>>>
>>> Moving to syscalls avoids these problems, but introduces new ones:
>>>
>>> - adding new syscalls is generally frowned upon, and kvm will need
>>> several
>>> - syscalls into modules are harder and rarer than into core kernel code
>>> - will need to add a vcpu pointer to task_struct, and a kvm pointer to
>>> mm_struct
>> - Lost a good place to put access control (permissions on /dev/kvm)
>> for which user-mode processes can use KVM.
>>
>> How would the ability to use sys_kvm_* be regulated?
> 
> Why should it be regulated?
> 
> It's not a finite or privileged resource.

You're exposing a large, complex kernel subsystem that does very
low-level things with the hardware.  It's a potential source of exploits
(from bugs in KVM or in hardware).  I can see people wanting to be
selective with access because of that.

And sometimes it is a finite resource.  I don't know how x86 does it,
but on at least some powerpc hardware we have a finite, relatively small
number of hardware partition IDs.

-Scott

