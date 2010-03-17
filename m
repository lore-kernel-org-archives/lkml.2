Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0CQIai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:30:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58118 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab0CQIag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:30:36 -0400
Message-ID: <4BA092AE.3090206@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 16:28:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: cleanup {kvm_vm_ioctl, kvm}_get_dirty_log()
References: <4BA0897F.3050906@cn.fujitsu.com> <4BA09023.4000706@oss.ntt.co.jp>
In-Reply-To: <4BA09023.4000706@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Takuya Yoshikawa wrote:

> 
> Oh, for such a tiny comment.

Your comment is valuable although it's tiny :-)

> 

> 
> What I said was just you may be able to use bitmap_empty() instead of
> 
>> -    for (i = 0; !is_dirty && i < n/sizeof(long); i++)
>> -        is_dirty = memslot->dirty_bitmap[i];
> 
> for x86's code too, if your patch for kvm_get_dirty_log() was correct.

While i look into x86's code, i found we can direct call kvm_get_dirty_log()
in kvm_vm_ioctl_get_dirty_log() to remove some unnecessary code, this is a
better cleanup way

Thanks,
Xiao
 
