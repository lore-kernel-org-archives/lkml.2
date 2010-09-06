Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab0IFJOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:14:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0IFJOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:14:52 -0400
Message-ID: <4C84B103.7020603@redhat.com>
Date: Mon, 06 Sep 2010 12:14:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: don't sent IPI if the vcpu is not online
References: <4C807593.1050903@cn.fujitsu.com> <4C83445B.4020103@redhat.com> <4C844887.9090802@cn.fujitsu.com> <4C84801F.9060803@redhat.com> <DCCDD62D-CE92-453A-BB3C-DF878D893C3F@suse.de> <4C84AC6B.4090306@redhat.com> <633F01D5-D6AD-40F3-8864-C3AE4D314E30@suse.de> <4C84AEF5.2070309@redhat.com> <F83E94AF-6BB0-4653-A81F-7D9F7D0B9E12@suse.de>
In-Reply-To: <F83E94AF-6BB0-4653-A81F-7D9F7D0B9E12@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 12:09 PM, Alexander Graf wrote:
>
>> It can also be running host kernel or user code.
> In that case it's the same as running guest code, no? We'll pass by the vcpu entry check asap.

Sure, but the IPI is wasted.  If you spend 10% of your time in host 
code, you can avoid 10% of the IPIs.

(actually less, since the atomic part of the guest switch has guest_mode 
enabled)

-- 
error compiling committee.c: too many arguments to function

