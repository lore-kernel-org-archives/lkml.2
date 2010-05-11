Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0EKOVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:21:48 -0400
Received: from fmailhost01.isp.att.net ([207.115.11.51]:33450 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EKOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:21:46 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 10:21:46 EDT
X-Originating-IP: [65.7.130.205]
Message-ID: <4BE964C2.1010702@turmel.org>
Date: Tue, 11 May 2010 10:08:02 -0400
From: Phil Turmel <pturmel-kernel@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100417 Thunderbird/3.0.4
MIME-Version: 1.0
To: Phil Reynolds <phil-linux@tinsleyviaduct.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Marvell eSATA - 88SE6121 on Asus M3A79-T Deluxe - not in AHCI
References: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
In-Reply-To: <20100509151358.84896yzx8vt059gm@topdeck.tinsleyviaduct.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Phil,

It seems no one noticed your question.  I've CC'd linux-scsi, in case the
experts have additional/better advice.

On 05/09/2010 10:13 AM, Phil Reynolds wrote:
> I have recently had cause to start using the eSATA port on my
> motherboard, an Asus M3A79-T Deluxe, but have found that it is not in
> AHCI mode and therefore not hotplug capable. There are no settings for
> the Marvell 88SE6121 controller available, other than simply whether it
> is enabled or not.
> 
> I gather from reading elsewhere that the kernel can put this controller
> into AHCI - I found a patch but found it was already present in the
> kernel in Debian lenny's backports. It is their version 2.6.32-bpo.3 -
> not entirely sure which exact source version this is built from.
> However, this patch does not work on this motherboard - either that or I
> have to make it active somehow, and the method of doing so is not obvious.
[snip /]

I have a similar chipset in my office server: 88SE6145.  If yours can run
in AHCI mode, you just need "ahci.marvell_enable=1" on your kernel command
line, or "options ahci marvell_enable=1" in your modprobe.conf.  (I have
ahci built-in, and no initramfs, so I put the option in my grub.conf.)

My Marvell chipset has both SATA and PATA ports... the PATA ports are
non-functional when the ahci driver runs the chipset.  Your mileage may
vary.

HTH,

Phil Turmel
