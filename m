Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768448Ab2KOQnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:43:17 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34422 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768417Ab2KOQnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:43:16 -0500
Date: Thu, 15 Nov 2012 10:42:42 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] char/tpm: simplify duration calculation and
 eliminate sparse warning.
Message-ID: <20121115164242.GD533@ennui.austin.ibm.com>
References: <1352759838-27175-1-git-send-email-peterhuewe@gmx.de>
 <1352759838-27175-2-git-send-email-peterhuewe@gmx.de>
 <20121114221826.GC533@ennui.austin.ibm.com>
 <201211142337.06884.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201211142337.06884.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111516-6078-0000-0000-000011F268A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 11:37:06PM +0100, Peter Hüwe wrote:
> Am Mittwoch, 14. November 2012, 23:18:26 schrieb Kent Yoder:
> > On Mon, Nov 12, 2012 at 11:37:18PM +0100, Peter Huewe wrote:> > 
> > > This patch also gets rid of the (false positive) sparse warning:
> > >  drivers/char/tpm/tpm.c:360 tpm_calc_ordinal_duration() error: buffer
> > >  overflow 'tpm_protected_ordinal_duration' 12 <= 243
> > 
> >   I'm not seeing this sparse warning, how did you get it?
> 
> Oh sorry 
> s/sparse/smatch/
> 
> It was a smatch warning, not sparse - sorry about that:

  Ah, ok. The only other nit I had was that the spec references "TSC"
ordinals, but you had defined "TCS_MAX_ORDINAL". TCS is actually a piece
of TSS in user-space.

Kent

> /data/data-old/linux-2.6/drivers/char/tpm $ make -C /data/data-old/linux-2.6/ M=`pwd`  C=1 CHECK=smatch
> make: Entering directory `/data/data-old/linux-2.6'
>   LD      /data/data-old/linux-2.6/drivers/char/tpm/built-in.o
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm.c
> /data/data-old/linux-2.6/drivers/char/tpm/tpm.c:360 tpm_calc_ordinal_duration() error: buffer overflow 'tpm_protected_ordinal_duration' 12 <= 243
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm.o
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_eventlog.c
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_eventlog.o
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_acpi.c
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_acpi.o
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_ppi.c
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_ppi.o
>   LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_bios.o
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_tis.c
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_tis.o
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_i2c_infineon.c
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_i2c_infineon.o
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_nsc.c
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_nsc.o
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_atmel.c
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_atmel.o
>   CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_infineon.c
>   CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_infineon.o
>   Building modules, stage 2.
>   MODPOST 7 modules
>   CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm.mod.o
>   LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm.ko
>   CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_atmel.mod.o
>   LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_atmel.ko
>   CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_bios.mod.o
>   LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_bios.ko
>   CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_i2c_infineon.mod.o
>   LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_i2c_infineon.ko
>   CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_infineon.mod.o
>   LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_infineon.ko
>   CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_nsc.mod.o
>   LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_nsc.ko
>   CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_tis.mod.o
>   LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_tis.ko
> make: Leaving directory `/data/data-old/linux-2.6'
> 

