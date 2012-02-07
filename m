Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2BGKEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:04:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab2BGKEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:04:53 -0500
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1328597934.6802.6.camel@concordia>
Date: Tue, 7 Feb 2012 11:04:44 +0100
Cc: Scott Wood <scottwood@freescale.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Eric Northup <digitaleric@google.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F1B17875-23E2-4965-BE05-6A3858995D21@suse.de>
References: <4F2AB552.2070909@redhat.com> <CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com> <4F2C6517.3040203@codemonkey.ws> <4F302E0D.20302@freescale.com> <1328597934.6802.6.camel@concordia>
To: michael@ellerman.id.au
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 07.02.2012, at 07:58, Michael Ellerman wrote:

> On Mon, 2012-02-06 at 13:46 -0600, Scott Wood wrote:
>> On 02/03/2012 04:52 PM, Anthony Liguori wrote:
>>> On 02/03/2012 12:07 PM, Eric Northup wrote:
>>>> On Thu, Feb 2, 2012 at 8:09 AM, Avi Kivity<avi@redhat.com>  wrote:
>>>> [...]
>>>>> 
>>>>> Moving to syscalls avoids these problems, but introduces new ones:
>>>>> 
>>>>> - adding new syscalls is generally frowned upon, and kvm will need
>>>>> several
>>>>> - syscalls into modules are harder and rarer than into core kernel code
>>>>> - will need to add a vcpu pointer to task_struct, and a kvm pointer to
>>>>> mm_struct
>>>> - Lost a good place to put access control (permissions on /dev/kvm)
>>>> for which user-mode processes can use KVM.
>>>> 
>>>> How would the ability to use sys_kvm_* be regulated?
>>> 
>>> Why should it be regulated?
>>> 
>>> It's not a finite or privileged resource.
>> 
>> You're exposing a large, complex kernel subsystem that does very
>> low-level things with the hardware.  It's a potential source of exploits
>> (from bugs in KVM or in hardware).  I can see people wanting to be
>> selective with access because of that.
> 
> Exactly.
> 
> In a perfect world I'd agree with Anthony, but in reality I think
> sysadmins are quite happy that they can prevent some users from using
> KVM.
> 
> You could presumably achieve something similar with capabilities or
> whatever, but a node in /dev is much simpler.

Well, you could still keep the /dev/kvm node and then have syscalls operate on the fd.

But again, I don't see the problem with the ioctl interface. It's nice, extensible and works great for us.


Alex

