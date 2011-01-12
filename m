Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab1ALKAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 05:00:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1ALJ76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:59:58 -0500
Message-ID: <4D2D7B93.40109@redhat.com>
Date: Wed, 12 Jan 2011 11:59:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Nadav Har'El" <nyh@math.technion.ac.il>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: send IPI to vcpu only when it's in guest
 mode
References: <4D2D5AA6.9080804@cn.fujitsu.com> <4D2D5AEF.1070006@cn.fujitsu.com> <20110112095428.GA15835@fermat.math.technion.ac.il>
In-Reply-To: <20110112095428.GA15835@fermat.math.technion.ac.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 11:54 AM, Nadav Har'El wrote:
> On Wed, Jan 12, 2011, Xiao Guangrong wrote about "[PATCH v3 2/3] KVM: send IPI to vcpu only when it's in guest mode":
> >  We can interrupt the vcpu only when it's running in guest mode
> >  to reduce IPI
>
> Hi,
>
> I am afraid there's a risk of confusion between the new
>
> 	vcpu->mode = IN_GUEST_MODE;
>
> and the existing
>
> 	is_guest_mode()   (i.e., vcpu->arch.hflags&  HF_GUEST_MASK)
>
> The latter says that the virtual cpu is in guest mode (i.e., the guest used
> VMLAUNCH and is runnning a nested guest), while the former says that the
> physical CPU that this vcpu is currently being run on, is in guest mode - or
> in other words, this vcpu is currently running.
>
> I'm not sure what is the best way to resolve this potential for confusion.
> Maybe on of them is better renamed (e.g., instead of vcpu->mode = IN_GUEST_MODE
> have something like vcpu->running = NOW_RUNNING). Or maybe some good comments
> need to to be written to explain the situation.
>
> Actually, I just noticed that there's already a vcpu->guest_mode which you
> are apparently replacing, so the potential for confusion is already in the
> current code... I.e., in the current code, is_guest_mode(vcpu) does NOT check
> vcpu->guest_mode...
>

Right.  One is from the host's point of view, the other is from the 
guest's point of view.  I'll rename is_guest_mode() to is_nested_guest().

-- 
error compiling committee.c: too many arguments to function

