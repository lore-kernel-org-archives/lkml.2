Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2KGRrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:47:36 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:48148 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2KGRrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:47:35 -0500
Date: Wed, 7 Nov 2012 11:45:58 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Mathias LEBLANC <Mathias.LEBLANC@st.com>
Cc: Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>
Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
Message-ID: <20121107174558.GC31862@ennui.austin.ibm.com>
References: <1352290509-14834-1-git-send-email-mathias.leblanc@st.com>
 <20121107150257.GD14628@ennui.austin.ibm.com>
 <35286B1AE75A7C47BFF0870081A31B4B387510DB14@SAFEX1MAIL4.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35286B1AE75A7C47BFF0870081A31B4B387510DB14@SAFEX1MAIL4.st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110717-5518-0000-0000-00000918CF3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 04:23:14PM +0100, Mathias LEBLANC wrote:
> Hi Kent,
> 
> Sorry for sending new driver, it was a mistake.
> Today, I will upload the new version of the Linux driver without the errors that you have mentioned in your previous mail.

  Ok, np.

> 
> About :
> > +/*
> > + * tpm_st33_i2c_ioctl provides 2 handles:
> > + * - TPMIOC_CANCEL: allow to CANCEL a TPM commands execution.
> > + *   See tpm_stm_i2c_cancel description above
> > + * - TPMIOC_TRANSMIT: allow to transmit a TPM commands.
> > + * - TPMIOC_HASH: allow to compute a locality 4 hash
> > + * - TPMIOC_CHANGELOCALITY: allow to change the current locality
> 
>   Can we get rid of the ioctl path?  cancel and transmit are available
> through read/write already, but I need help understanding what hash and
> change locality would be useful for. If the kernel is running you can
> just use the crypto api for a hash operation, right?
> 
>   As for changing locality, what's the idea there? If you can just
> switch localities at any time with an ioctl and no DRTM, why have it?
> 
> [cut]
> > +static const struct file_operations tpm_st33_i2c_fops = {
> > +     .owner = THIS_MODULE,
> > +     .llseek = no_llseek,
> > +     .read = tpm_read,
> > +     .write = tpm_write,
> > +     .open = tpm_open,
> > +     .release = tpm_release,
> > +};
> 
> The TPM specification, specifies all four localities used for different levels
> LOCALITY4_HASH by a CPU instruction to start
> LOCALITY3 for BIOS
> LOCALITY2 for MBR
> LOCALITY1 for operation login
> LOCALITY0 for common OS tasks.
> 
> The use of these localities is agreement with the specifications and must always be down (4, 3, 2, 1, 0) to be sure that the verification steps lower levels will never be altered to ensure "sustainability".
> If once the OS loaded, I am able to use the locality 4, I could potentially alter the values ​​of the starting steps below ...
> Access to these localities in the driver * Linux * has been given only for the purpose of validation.

  Ok cool, so it can be removed? :-)

Kent

> ________________________________________
> From: Kent Yoder [key@linux.vnet.ibm.com]
> Sent: 07 November 2012 16:02
> To: Mathias LEBLANC
> Cc: Rajiv Andrade; Marcel Selhorst; Sirrix AG; tpmdd-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; Jean-Luc BLANC
> Subject: Re: [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
> 
> On Wed, Nov 07, 2012 at 01:15:09PM +0100, Mathias Leblanc wrote:
> >  * STMicroelectronics version 1.2.0, Copyright (C) 2010
> >  * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> >  * This is free software, and you are welcome to redistribute it
> >  * under certain conditions.
> >
> > This is the driver for TPM chip from ST Microelectronics.
> >
> > If you have a TPM security chip from STMicroelectronics working with
> > an I2C, in menuconfig or .config choose the tpm driver on
> > device --> tpm and activate the protocol of your choice before compiling
> > the kernel.
> > The driver will be accessible from within Linux.
> >
> > Tested on linux x86/x64, beagleboard REV B & XM REV C and CHROMIUM OS
> >
> > Signed-off-by: Mathias Leblanc <mathias.leblanc@st.com>
> 
> Hi Mathias,
> 
>   I didn't see a reply to my mail from Oct 31, and very little has
> changed here.  Did I miss something?
> 
> Kent

