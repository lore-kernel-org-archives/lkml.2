Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab0EDPEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:04:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab0EDPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:03:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [RFC][PATCH resend 8/12] asm-generic: bitops: introduce le bit offset macro
Date: Tue, 4 May 2010 17:03:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <20100504220500.7695cd66.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504220500.7695cd66.takuya.yoshikawa@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005041703.00549.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/xvNLctGuTZwJhhcFPAVN+XDnaIMNpYhPyR7b
 zJShLpQ8q9U3vf0RQsyUi+Wf3rsybGbHwPdAMP7R+fZBvXbl5g
 9MFW2MKwJ8UOSWIO50K2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 May 2010, Takuya Yoshikawa wrote:
> 
> Although we can use *_le_bit() helpers to treat bitmaps le arranged,
> having le bit offset calculation as a seperate macro gives us more freedom.
> 
> For example, KVM has le arranged dirty bitmaps for VGA, live-migration
> and they are used in user space too. To avoid bitmap copies between kernel
> and user space, we want to update the bitmaps in user space directly.
> To achive this, le bit offset with *_user() functions help us a lot.
> 
> So let us use the le bit offset calculation part by defining it as a new
> macro: generic_le_bit_offset() .

Does this work correctly if your user space is 32 bits (i.e. unsigned long
is different size in user space and kernel) in both big- and little-endian
systems?

I'm not sure about all the details, but I think you cannot in general share
bitmaps between user space and kernel because of this.

	Arnd
