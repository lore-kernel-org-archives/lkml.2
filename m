Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab0IFIvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:51:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:60623 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab0IFIvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:51:09 -0400
Subject: Re: [PATCH] KVM: don't sent IPI if the vcpu is not online
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4C84801F.9060803@redhat.com>
Date: Mon, 6 Sep 2010 10:51:04 +0200
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DCCDD62D-CE92-453A-BB3C-DF878D893C3F@suse.de>
References: <4C807593.1050903@cn.fujitsu.com> <4C83445B.4020103@redhat.com> <4C844887.9090802@cn.fujitsu.com> <4C84801F.9060803@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06.09.2010, at 07:46, Avi Kivity wrote:

> On 09/06/2010 04:48 AM, Xiao Guangrong wrote:
>> On 09/05/2010 03:18 PM, Avi Kivity wrote:
>>>  On 09/03/2010 07:12 AM, Xiao Guangrong wrote:
>>>> It's no need sent IPI to the vcpu which is schedule out
>>>> 
>>>> 
>>>> @@ -86,6 +86,7 @@ struct kvm_vcpu {
>>>>       unsigned long requests;
>>>>       unsigned long guest_debug;
>>>>       int srcu_idx;
>>>> +    bool online;
>>> Why not check for guest_mode instead?
>>> 
>> Oh, i forget it...but 'vcpu->guest_mode' is only used in x86 platform,
>> and make_all_cpus_request() is a common function.
> 
> We can have a function kvm_vcpu_guest_mode() that is defined differently for x86 and the other.
> 
>> So, maybe it's better use 'vcpu->online' here, and move 'guest_mode' into
>> 'vcpu->arch' ?
> 
> I think guest_mode makes sense for the other archs for reducing IPIs, so let's leave it common and recommend that they implement it.  Alex, if you're ever bored.

What does the bit do? Do we have documentation on it ;)? No seriously, what's the intent of the field?


Alex

