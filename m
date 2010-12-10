Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0LJKt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:49:57 -0500
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:44523 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753227Ab0LJKtz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:49:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=N5pfNAVeiZqlb9+jsj5NGnuuDgY9TlWXo83p0CKi4HRHpaEmggOZDBLeyXR0NK7+bAJmfpLDrMR28scpVv1g6X+Oiz7lwOnS7xl9Q+ZgX83ptk4tMccrqF0WfqQr8SCILGtuHtP7juiAawOsURhFUlsIQ6IANPeQCpZXHmbzj4I=;
Message-ID: <823199.4758.qm@web31810.mail.mud.yahoo.com>
X-YMail-OSG: 6OyIyCYVM1my5KtC5OqU2urXqx_yHNqlp.vBPwGU4bNvKyq
 b3Lc.dHmifwvEy75QKZ.Q939YQzLkLwYOOtR9bD9jOvHkkiuc0Q.B37T5T9r
 EMuEVPpqcbr.K0mlnbcgD9hAHmOBlGYhr4HD95YZ8Jy1T9hrBgXCj.f_DQMk
 HH53dq1HS457WrI__F.wOy9cE1sXX_muJx_OySMR_s8WrABQlN.96PkDUYo3
 u3CLiC9H2ctX4mHVU3_3Bqzl.5g.dvPpd7hTZUL.Skyfb88dIWW7p2zuc7FB
 ZcC3VhB1BtHKrm3jWV9DnCAks5sJJba7xwGGWiylIGA57zrUO2PsljN4URe_
 B2H4uTvFboZe3COJHSLNoAuhBVeq7MzFKqgwflfiQeh1WB0ioyLmsI226Qzu
 oO0_mwTMbrsCC
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Fri, 10 Dec 2010 02:49:53 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        willy@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch retracted for this still-born driver. Instead please use superior uasp.c which was recently submitted.

--- On Wed, 10/27/10, Luben Tuikov <ltuikov@yahoo.com> wrote:

> From: Luben Tuikov <ltuikov@yahoo.com>
> Subject: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
> To: "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, willy@linux.intel.com
> Date: Wednesday, October 27, 2010, 1:22 PM
> "Be conservative in what you send,
> liberal in what
> you accept." -- In the spirit of this adage, don't
> send Command IUs with randomly filled in data in
> the reserved fields. (Yes, this shows up on the
> wire.)
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/usb/storage/uas.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas.c
> b/drivers/usb/storage/uas.c
> index 2054b1e..17e1820 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -294,7 +294,7 @@ static struct urb
> *uas_alloc_sense_urb(struct uas_dev_info *devinfo, gfp_t
> gfp,
>      if (!urb)
>          goto out;
>  
> -    iu = kmalloc(sizeof(*iu), gfp);
> +    iu = kzalloc(sizeof(*iu), gfp);
>      if (!iu)
>          goto free;
>  
> @@ -325,7 +325,7 @@ static struct urb
> *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
>      if (len < 0)
>          len = 0;
>      len = ALIGN(len, 4);
> -    iu = kmalloc(sizeof(*iu) + len, gfp);
> +    iu = kzalloc(sizeof(*iu) + len, gfp);
>      if (!iu)
>          goto free;
>  
> @@ -660,7 +660,7 @@ static int uas_probe(struct
> usb_interface *intf, const struct usb_device_id *id)
>             
> return -ENODEV;
>      }
>  
> -    devinfo = kmalloc(sizeof(struct
> uas_dev_info), GFP_KERNEL);
> +    devinfo = kzalloc(sizeof(struct
> uas_dev_info), GFP_KERNEL);
>      if (!devinfo)
>          return -ENOMEM;
>  
> -- 
> 1.7.0.1
> 
> 
