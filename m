Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1HCIKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:10:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1HCIKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:10:48 -0400
Message-ID: <4E390283.6050106@redhat.com>
Date: Wed, 03 Aug 2011 11:10:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 05/12] KVM: x86: fast emulate repeat string write instructions
References: <4E37DA49.1040000@cn.fujitsu.com> <4E37DADE.1070306@cn.fujitsu.com>
In-Reply-To: <4E37DADE.1070306@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 02:09 PM, Xiao Guangrong wrote:
> We usually use repeat string instructions to clear the page, for example,
> we call memset to clear a page table, stosb is used in this function, and
> repeated for 1024 times, that means we should occupy mmu lock for 1024 times
> and walking shadow page cache for 1024 times, it is terrible
>
> In fact, if it is the repeat string instructions emulated and it is not a
> IO/MMIO access, we can zap all the corresponding shadow pages and return to the
> guest, then the mapping can became writable and we can directly write the page
>

This isn't needed if we zap before emulating, right?

-- 
error compiling committee.c: too many arguments to function

