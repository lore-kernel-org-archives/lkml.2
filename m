Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2BALKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:10:40 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48658 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab2BALKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:10:38 -0500
Message-ID: <4F291E1F.3030505@oss.ntt.co.jp>
Date: Wed, 01 Feb 2012 20:12:31 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
References: <1328016724.2446.229.camel@twins> <4F27F0E6.1040309@redhat.com>  <1328017807.2446.230.camel@twins>  <20120131222447.GH2391@linux.vnet.ibm.com> <1328091749.2760.34.camel@laptop> <4F29178A.1090306@redhat.com> <4F2918D5.4050104@redhat.com> <4F291B56.30600@oss.ntt.co.jp> <4F291B92.8070402@redhat.com>
In-Reply-To: <4F291B92.8070402@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/01 20:01), Avi Kivity wrote:
> On 02/01/2012 01:00 PM, Takuya Yoshikawa wrote:

>> How about just doing:
>>
>> take a spin_lock
>> copy the entire (or some portions of) bitmap locally
>> clear the bitmap
>> unlock
>>
>
> That means that vcpus dirtying memory also have to take that lock, and
> spin while the bitmap is being copied.  So kvm_vm_ioctl_get_dirty_log()
> will become faster, at the expense of vcpus, which I think is a bad
> tradeoff.

Almost every caller is already holding the mmu_lock.

Isn't it possible to make others hold the lock only for the case of
marking to the bitmap? (I will check myself too.)


>> write protect the dirty pages based on the copied dirty data
>>
>> copy_to_user
>>
>>
>>
>> I can show you some performance numbers, this weekend, if you like.
>
> That'll be great, numbers are better than speculation.
>

Yes, I already have some good numbers to show (and some patches).

	Takuya
