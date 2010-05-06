Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab0EFNjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 09:39:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab0EFNjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 09:39:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [RFC][PATCH resend 8/12] asm-generic: bitops: introduce le bit offset macro
Date: Thu, 6 May 2010 15:38:54 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <4BE04677.4060608@redhat.com> <20100505115924.7bb92036.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100505115924.7bb92036.takuya.yoshikawa@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005061538.54326.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18/iTQvsLwXxvqdQKVGUJ1Ol/oaK4BYk1/VY2l
 e/UQSKtANNsQjuInvjnWoyEZr9SqT+bvpI2XPREEdonixSgpwL
 ER8Z75afBAVdrtUyxxv/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Takuya Yoshikawa wrote:
> Date: 
> Yesterday 04:59:24
> > That's why the bitmaps are defined as little endian u64 aligned, even on 
> > big endian 32-bit systems.  Little endian bitmaps are wordsize agnostic, 
> > and u64 alignment ensures we can use long-sized bitops on mixed size 
> > systems.

Ok, I see.

> There was a suggestion to propose set_le_bit_user() kind of macros.
> But what I thought was these have a constraint you two explained and seemed to be
> a little bit specific to some area, like KVM.
> 
> So I decided to propose just the offset calculation macro.

I'm not sure I understand how this macro is going to be used though.
If you are just using this in kernel space, that's fine, please go for
it.

However, if the intention is to use the same macro in user space, putting
it into asm-generic/bitops/* is not going to help, because those headers
are not available in user space, and I wouldn't want to change that.

The definition of the macro is not part of the ABI, so just duplicate
it in KVM if you need it there.

	Arnd
