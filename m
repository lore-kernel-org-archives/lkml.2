Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0CQIiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:38:51 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:36480 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab0CQIiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:38:50 -0400
Message-ID: <4BA095B9.3010109@oss.ntt.co.jp>
Date: Wed, 17 Mar 2010 17:41:29 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: cleanup {kvm_vm_ioctl, kvm}_get_dirty_log()
References: <4BA0897F.3050906@cn.fujitsu.com> <4BA09023.4000706@oss.ntt.co.jp> <4BA092AE.3090206@cn.fujitsu.com>
In-Reply-To: <4BA092AE.3090206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong wrote:
> 
> Takuya Yoshikawa wrote:
> 
>> Oh, for such a tiny comment.
> 
> Your comment is valuable although it's tiny :-)
> 
> 
>> What I said was just you may be able to use bitmap_empty() instead of
>>
>>> -    for (i = 0; !is_dirty && i < n/sizeof(long); i++)
>>> -        is_dirty = memslot->dirty_bitmap[i];
>> for x86's code too, if your patch for kvm_get_dirty_log() was correct.
> 
> While i look into x86's code, i found we can direct call kvm_get_dirty_log()
> in kvm_vm_ioctl_get_dirty_log() to remove some unnecessary code, this is a
> better cleanup way

Ah, probably checking the git log will explain you why it is like that!
Marcelo's work? IIRC.

> 
> Thanks,
> Xiao
>  

