Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab0EJLnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:43:13 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48900 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab0EJLnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:43:09 -0400
Message-ID: <4BE7F22E.9070504@oss.ntt.co.jp>
Date: Mon, 10 May 2010 20:46:54 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, Avi Kivity <avi@redhat.com>,
       mtosatti@redhat.com, agraf@suse.de, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH resend 8/12] asm-generic: bitops: introduce le bit
 offset macro
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <4BE04677.4060608@redhat.com> <20100505115924.7bb92036.takuya.yoshikawa@gmail.com> <201005061538.54326.arnd@arndb.de>
In-Reply-To: <201005061538.54326.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/05/06 22:38), Arnd Bergmann wrote:
> On Wednesday 05 May 2010, Takuya Yoshikawa wrote:
>> Date:
>> Yesterday 04:59:24
>>> That's why the bitmaps are defined as little endian u64 aligned, even on
>>> big endian 32-bit systems.  Little endian bitmaps are wordsize agnostic,
>>> and u64 alignment ensures we can use long-sized bitops on mixed size
>>> systems.
>
> Ok, I see.
>
>> There was a suggestion to propose set_le_bit_user() kind of macros.
>> But what I thought was these have a constraint you two explained and seemed to be
>> a little bit specific to some area, like KVM.
>>
>> So I decided to propose just the offset calculation macro.
>
> I'm not sure I understand how this macro is going to be used though.
> If you are just using this in kernel space, that's fine, please go for
> it.

Yes, I'm just using in kernel space: qemu has its own endian related helpers.

So if you allow us to place this macro in asm-generic/bitops/* it will help us.

Avi, what do you think? Do you want to place it in kvm.h ?


>
> However, if the intention is to use the same macro in user space, putting
> it into asm-generic/bitops/* is not going to help, because those headers
> are not available in user space, and I wouldn't want to change that.
>
> The definition of the macro is not part of the ABI, so just duplicate
> it in KVM if you need it there.
>
> 	Arnd

