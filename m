Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab0KRR0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:26:00 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:33751 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab0KRRZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:25:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Pj9jq7IiT43+B+Wcac15opJIWlcaQ0Z55jVodmCvPpOfbDHeh3UutY4r0PXVKT2/Sy
         JxQa5ynzrYmt/KSZqg8rAirE3NKwPtzIxgeEMo0BhHQXLPTYIjUH8YZL3YQ3e5mRWP64
         4cvnzIVtBAymWbLoAwscSXLHz9+ugDQxYPnH0=
Message-ID: <4CE561A2.2020600@gmail.com>
Date: Thu, 18 Nov 2010 09:25:54 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-net@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: error while building the kernel Mainline
References: <AANLkTikToBjx-4go9mAFCcnTQ5X4Su+57ODoY9C5y_7f@mail.gmail.com> <1290093135.2781.167.camel@edumazet-laptop>
In-Reply-To: <1290093135.2781.167.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 07:12 AM, Eric Dumazet wrote:
> Le jeudi 18 novembre 2010 à 06:36 -0800, Justin Mattock a écrit :
>> hit this yesterday, and havent had time to look at it, to see if its a
>> simple fix
>>
>>    MODPOST vmlinux.o
>> WARNING: modpost: Found 1 section mismatch(es).
>> To see full details build your kernel with:
>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>>    GEN     .version
>>    CHK     include/generated/compile.h
>>    UPD     include/generated/compile.h
>>    CC      init/version.o
>>    LD      init/built-in.o
>>    LD      .tmp_vmlinux1
>> net/built-in.o: In function `handle_response_icmp':
>> ip_vs_core.c:(.text+0x2b5c4): undefined reference to `nf_conntrack_untracked'
>> net/built-in.o: In function `T.925':
>> ip_vs_core.c:(.text+0x2cbbd): undefined reference to `nf_conntrack_untracked'
>> net/built-in.o: In function `ip_vs_null_xmit':
>> (.text+0x310da): undefined reference to `nf_conntrack_untracked'
>> net/built-in.o: In function `ip_vs_tunnel_xmit':
>> (.text+0x311e3): undefined reference to `nf_conntrack_untracked'
>> net/built-in.o: In function `ip_vs_nat_xmit':
>> (.text+0x3176f): undefined reference to `nf_conntrack_untracked'
>> net/built-in.o:(.text+0x3199d): more undefined references to
>> `nf_conntrack_untracked' follow
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> has there been anything sent forward for this yet?
>>
>
> Try to find out why net/netfilter/nf_conntrack_core.c is not compiled ?

seems it is compiling, it's after the compiling when this breaks

>
> ./net/netfilter/nf_conntrack_core.c:65:DEFINE_PER_CPU(struct nf_conn, nf_conntrack_untracked);
> ./net/netfilter/nf_conntrack_core.c:66:EXPORT_PER_CPU_SYMBOL(nf_conntrack_untracked);
>
>
>
>

Justin P. Mattock
