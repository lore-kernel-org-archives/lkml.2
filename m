Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0IFIzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:55:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab0IFIzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:55:18 -0400
Message-ID: <4C84AC6B.4090306@redhat.com>
Date: Mon, 06 Sep 2010 11:55:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: don't sent IPI if the vcpu is not online
References: <4C807593.1050903@cn.fujitsu.com> <4C83445B.4020103@redhat.com> <4C844887.9090802@cn.fujitsu.com> <4C84801F.9060803@redhat.com> <DCCDD62D-CE92-453A-BB3C-DF878D893C3F@suse.de>
In-Reply-To: <DCCDD62D-CE92-453A-BB3C-DF878D893C3F@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 11:51 AM, Alexander Graf wrote:
>
>> I think guest_mode makes sense for the other archs for reducing IPIs, so let's leave it common and recommend that they implement it.  Alex, if you're ever bored.
> What does the bit do? Do we have documentation on it ;)? No seriously, what's the intent of the field?
>

It indicates that the vcpu is currently executing guest code.  Which in 
turn is important if you need to force it out of guest mode in order to 
inject an interrupt or flush the tlb.

The procedure is:

remote:
- queue a request in vcpu->requests
- IPI vcpu->cpu (new: only if in guest_mode)

vcpu:
- set guest_mode
- dequeue and execute requests in vcpu->requests
- enter guest
- clear guest_mode

-- 
error compiling committee.c: too many arguments to function

