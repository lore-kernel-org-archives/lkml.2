Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab0IFJJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:09:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:33052 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab0IFJJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:09:39 -0400
Subject: Re: [PATCH] KVM: don't sent IPI if the vcpu is not online
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4C84AEF5.2070309@redhat.com>
Date: Mon, 6 Sep 2010 11:09:37 +0200
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F83E94AF-6BB0-4653-A81F-7D9F7D0B9E12@suse.de>
References: <4C807593.1050903@cn.fujitsu.com> <4C83445B.4020103@redhat.com> <4C844887.9090802@cn.fujitsu.com> <4C84801F.9060803@redhat.com> <DCCDD62D-CE92-453A-BB3C-DF878D893C3F@suse.de> <4C84AC6B.4090306@redhat.com> <633F01D5-D6AD-40F3-8864-C3AE4D314E30@suse.de> <4C84AEF5.2070309@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06.09.2010, at 11:05, Avi Kivity wrote:

> On 09/06/2010 11:59 AM, Alexander Graf wrote:
>> On 06.09.2010, at 10:55, Avi Kivity wrote:
>> 
>>> On 09/06/2010 11:51 AM, Alexander Graf wrote:
>>>>> I think guest_mode makes sense for the other archs for reducing IPIs, so let's leave it common and recommend that they implement it.  Alex, if you're ever bored.
>>>> What does the bit do? Do we have documentation on it ;)? No seriously, what's the intent of the field?
>>>> 
>>> It indicates that the vcpu is currently executing guest code.  Which in turn is important if you need to force it out of guest mode in order to inject an interrupt or flush the tlb.
>> Well, a vcpu is either offline in halt state or in guest mode, no? So we can conclude that guest_mode == !offline&&  !halt_state.
> 
> It can also be running host kernel or user code.

In that case it's the same as running guest code, no? We'll pass by the vcpu entry check asap.

Alex

