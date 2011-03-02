Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab1CBUYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:24:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1CBUYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:24:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH v8 1/1] PRUSS UIO driver support
Date: Wed, 2 Mar 2011 21:23:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: Pratheesh Gangadhar <pratheesh@ti.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de, tglx@linutronix.de, sshtylyov@mvista.com,
        amit.chatterjee@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
References: <1299065886-30099-1-git-send-email-pratheesh@ti.com> <1299065886-30099-2-git-send-email-pratheesh@ti.com> <20110302200956.GB23818@local>
In-Reply-To: <20110302200956.GB23818@local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103022123.38050.arnd@arndb.de>
X-Provags-ID: V02:K0:WenYzJdpWHuFXQyslMG3yvp4nfFCfQqOChYaeM+ureW
 FONwjBVW4dK9cmRoFFaqufebI2ZwFBKDWUQCp6T7YifgSOIimS
 8kGcwKwQrRG6Sj3u/0yfAtAznXOruVsKz27B6c8pXamGQCq88v
 FgGI/prtolb4SegsCsz4P5HpP+xTdp4Y6WK+XhEr3oLy0lwdC8
 oZ6URva2NhPFegeffC8FA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 March 2011 21:09:56 Hans J. Koch wrote:
> > +static struct uio_info *info;
> > +static dma_addr_t sram_paddr, ddr_paddr;
> > +static void *prussio_vaddr, *sram_vaddr, *ddr_vaddr;
> 
> So the correct thing would be
> 
> static void __iomem *prussio_vaddr;
> static void *sram_vaddr, *ddr_vaddr;

I also commented that it should not be a global variable at
all, but a dynamic data structure referenced from the device.

Not important, but Pratheesh said he'd change it. If it stays
a global variable, I'd at least expect an explanation why
the static variable is considered better in this case.

	Arnd
