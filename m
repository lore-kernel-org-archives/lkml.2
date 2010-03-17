Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab0CQE3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:29:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53233 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab0CQE3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:29:12 -0400
Message-ID: <4BA05A1C.3090001@cn.fujitsu.com>
Date: Wed, 17 Mar 2010 12:27:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: cleanup kvm_get_dirty_log()
References: <4BA05040.4000101@cn.fujitsu.com> <4BA05A92.7090102@oss.ntt.co.jp>
In-Reply-To: <4BA05A92.7090102@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Takuya Yoshikawa wrote:
> Xiao Guangrong wrote:
>> Using bitmap_empty() to see whether memslot->dirty_bitmap is empty
>>
> 
> You can do this for arch specific get_dirty_log() too.

OK, i'll do it in the next version

> 
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  virt/kvm/kvm_main.c |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index bcd08b8..497ae14 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -767,8 +767,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
>>              struct kvm_dirty_log *log, int *is_dirty)
>>  {
>>      struct kvm_memory_slot *memslot;
>> -    int r, i;
>> -    int n;
>> +    int r, n;
>>      unsigned long any = 0;
> 
> any is no longer need to be unsigned long, if you do this?

Yeah, right, thanks for you point out.

Xiao
