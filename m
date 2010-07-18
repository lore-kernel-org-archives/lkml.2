Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab0GROWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:22:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab0GROWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:22:31 -0400
Message-ID: <4C430E23.9070707@redhat.com>
Date: Sun, 18 Jul 2010 17:22:27 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Zachary Amsden <zamsden@redhat.com>, KVM <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: KVM timekeeping fixes, V2
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <20100716131907.GJ23755@8bytes.org> <4C4094E0.7000403@redhat.com> <20100716192637.GK23755@8bytes.org>
In-Reply-To: <20100716192637.GK23755@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 10:26 PM, Joerg Roedel wrote:
> On Fri, Jul 16, 2010 at 07:20:32AM -1000, Zachary Amsden wrote:
>
>    
>> I've been very careful to keep nested SVM safe, but I've not got a good
>> test for that.  Is there any test suite for the nested case?
>>      
> To test this you can boot a nested Linux guest and let both, L1 and L2
> guest use kvm_clock. Then put some load into the L2 guest and see if the
> L2 or the L1 freezes hard (which happens with kvm_clock when the TSC
> went backwards for one of them).
>
>    

With recent guests, they won't freeze any more, since we detect the tsc 
going backwards and compensate (in a brute-force way, nothing clever).

But you can printk the maximum compensation and see if it's something 
unreasonable.

-- 
error compiling committee.c: too many arguments to function

