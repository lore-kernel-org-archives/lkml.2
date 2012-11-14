Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423555Ab2KNW26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:28:58 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:39202 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1423512Ab2KNW24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:28:56 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18GufBUcv4G8QL90RzWOgmnL4OJKLnKNsHLSfwZN9
	LjFbTgBhzQ0/8X
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] char/tpm: simplify duration calculation and eliminate sparse warning.
Date: Wed, 14 Nov 2012 23:37:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.6; KDE/4.8.5; x86_64; ; )
Cc: Marcel Selhorst <tpmdd@selhorst.net>, Sirrix AG <tpmdd@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1352759838-27175-1-git-send-email-peterhuewe@gmx.de> <1352759838-27175-2-git-send-email-peterhuewe@gmx.de> <20121114221826.GC533@ennui.austin.ibm.com>
In-Reply-To: <20121114221826.GC533@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211142337.06884.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 14. November 2012, 23:18:26 schrieb Kent Yoder:
> On Mon, Nov 12, 2012 at 11:37:18PM +0100, Peter Huewe wrote:> > 
> > This patch also gets rid of the (false positive) sparse warning:
> >  drivers/char/tpm/tpm.c:360 tpm_calc_ordinal_duration() error: buffer
> >  overflow 'tpm_protected_ordinal_duration' 12 <= 243
> 
>   I'm not seeing this sparse warning, how did you get it?

Oh sorry 
s/sparse/smatch/

It was a smatch warning, not sparse - sorry about that:

/data/data-old/linux-2.6/drivers/char/tpm $ make -C /data/data-old/linux-2.6/ M=`pwd`  C=1 CHECK=smatch
make: Entering directory `/data/data-old/linux-2.6'
  LD      /data/data-old/linux-2.6/drivers/char/tpm/built-in.o
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm.c
/data/data-old/linux-2.6/drivers/char/tpm/tpm.c:360 tpm_calc_ordinal_duration() error: buffer overflow 'tpm_protected_ordinal_duration' 12 <= 243
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm.o
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_eventlog.c
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_eventlog.o
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_acpi.c
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_acpi.o
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_ppi.c
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_ppi.o
  LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_bios.o
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_tis.c
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_tis.o
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_i2c_infineon.c
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_i2c_infineon.o
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_nsc.c
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_nsc.o
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_atmel.c
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_atmel.o
  CHECK   /data/data-old/linux-2.6/drivers/char/tpm/tpm_infineon.c
  CC [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_infineon.o
  Building modules, stage 2.
  MODPOST 7 modules
  CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm.mod.o
  LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm.ko
  CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_atmel.mod.o
  LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_atmel.ko
  CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_bios.mod.o
  LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_bios.ko
  CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_i2c_infineon.mod.o
  LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_i2c_infineon.ko
  CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_infineon.mod.o
  LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_infineon.ko
  CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_nsc.mod.o
  LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_nsc.ko
  CC      /data/data-old/linux-2.6/drivers/char/tpm/tpm_tis.mod.o
  LD [M]  /data/data-old/linux-2.6/drivers/char/tpm/tpm_tis.ko
make: Leaving directory `/data/data-old/linux-2.6'
