Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2G0OvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 10:51:06 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42668 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2G0OvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 10:51:04 -0400
Date: Fri, 27 Jul 2012 09:49:59 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        m.selhorst@sirrix.com, safford@us.ibm.com
Subject: Re: [PATCH 1/2] tpm: Move tpm_get_random api into the TPM device
 driver
Message-ID: <20120727144959.GA22046@linux.vnet.ibm.com>
References: <1339094567.21398.2.camel@key-ThinkPad-W510>
 <1339094834.21398.4.camel@key-ThinkPad-W510>
 <5011C0C3.4090009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5011C0C3.4090009@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072714-5518-0000-0000-00000662B0E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 03:12:19PM -0700, H. Peter Anvin wrote:
> On 06/07/2012 11:47 AM, Kent Yoder wrote:
> >Move the tpm_get_random api from the trusted keys code into the TPM
> >device driver itself so that other callers can make use of it. Also,
> >change the api slightly so that the number of bytes read is returned in
> >the call, since the TPM command can potentially return fewer bytes than
> >requested.
> >
> >Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> 
> >+int tpm_get_random(u32 chip_num, u8 *out, size_t *max)
> 
> /* ... */
> 
> >  	case Opt_new:
> >-		ret = my_get_random(payload->key, payload->key_len);
> >+		ret = tpm_get_random(TPM_ANY_NUM, payload->key,
> >+				     &payload->key_len);
> 
> payload->key_len is unsigned int, not size_t; this causes an
> overwrite of blob_len on 64-bit platforms.

  Good catch.

Thanks,
Kent

> 
> 	-hpa
> 
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

