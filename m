Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab1FJFII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 01:08:08 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56663 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1FJFIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 01:08:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ZSiwSFG3JwLFL6JN7aAJj2UCfQtAa5K8m1x0pJQ5ZQnsbGImIrnd2T4toObWjC7pAP
         G2IY0F75CKstMlxUh2MT7HvkDa4BGM72/uSPmM0MFyQ98iihVs3lTRmG+Fg9lFq2QS7V
         QC25UWp5NhPbachCBQ25AkfmyiXDWFwa0cd2U=
Date: Fri, 10 Jun 2011 13:07:50 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Connor Hansen <cmdkhh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND]Remove a warning for drivers/edac/i82975x_edac.c
Message-ID: <20110610050747.GA3643@gmail.com>
Mail-Followup-To: Connor Hansen <cmdkhh@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20110609030401.GA2615@gmail.com>
 <BANLkTim_=2kWXAzkECC4A3t9uxGERwBU7g@mail.gmail.com>
 <20110609052509.GA3997@gmail.com>
 <BANLkTin-iC8HFm2dmCmRTfYcBDDRbjZnFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <BANLkTin-iC8HFm2dmCmRTfYcBDDRbjZnFw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 11:17:21PM -0700, Connor Hansen wrote:
> 
> this is not what the code you are changing does.
> 
> the code is not assigned that value, its or'd with it.
> 
> a test would be more like.
> 
> #include <stdio.h>
> int main()
> {
>         unsigned long page;  //page
>         unsigned int b = 5;  //info->eap is u32 = unsigned int
>                                        // typedef unsigned int __u32;
>         page = (unsigned long) b;
>         page |= 0x10000000ul;
> 
>         printf("%lu\n",page);
> 
>         return 0;
> }
> 
> This produces no warning.
> $ gcc -g test.c && ./a.out
> 268435461
> $
> 
> 0x10000000
> 10000000000000000000000000000
> 5
> 00000000000000000000000000101
> 0x10000000 | 5 =
> 10000000000000000000000000101
> 268435461
> 
> I am green to kernel development so I will wait for someone with a bit
> more knowledge to
> chime in, or verify this warning.
> Connor

You are right, but it really has warnings yet.
My PC is also 32-bits.

Thanks
Harry Wei
