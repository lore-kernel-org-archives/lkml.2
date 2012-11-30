Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab2K3TrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:47:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36294 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab2K3TrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:47:11 -0500
Message-ID: <50B90D05.2030002@zytor.com>
Date: Fri, 30 Nov 2012 11:46:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v2 01/10] Documentation/x86: Early load microcode
References: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com> <1354240068-9821-2-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1354240068-9821-2-git-send-email-fenghua.yu@intel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 05:47 PM, Fenghua Yu wrote:
> +
> +mkdir initrd
> +cd initrd
> +cp ../microcode.hex kernel/x86/microcode/GenuineIntel/microcode.hex
> +find .|cpio -oc >../ucode.cpio
> +cd ..
> +cat ucode.cpio /boot/initrd-3.5.0.img >/boot/initrd-3.5.0.ucode.img
> +
> +The generated /boot/initrd-3.5.0.ucode.img can be used as initrd file to load
> +microcode during early boot time.
> 

This is wrong; first of all, this refers to microcode.hex whereas the
patch refers to microcode.bin, and it misses the mandatory -H newc
option to cpio.

Could you update this bit, please?

	-hpa

