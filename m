Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0LJKut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:50:49 -0500
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:23567 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753228Ab0LJKus convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:50:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=dRApB0AFQQ5adyeJbtWd1rSJWyUiNhjwzNtWT/djEK6UKeHPdn7cXx6Bn3NgDNlBgXsvK5lDecFCBdsoopiW0adsXeM7kkwqsgqvIcAGyilCvBrZ59IWShTMO8nkLfTK5+ewiJTbZaGMKyfpDToq8rtj6p5evNDnGWtu/U+E6Yg=;
Message-ID: <323235.6308.qm@web31804.mail.mud.yahoo.com>
X-YMail-OSG: Dj4Sq3IVM1lad8sPvtKpzQnx8QO7X5qqfjPqWgWUJc6Nrw6
 cUOMs1LnJQQKdhl_qp6EQTtENnQSLPImTyLJtNFIdTnIj8ndCOlbUB1vLcAI
 1r6HFFsoHLR7ANr2dEdWzev0fRKaJAykkutqVdlR3naTNrM2eaAtYkdATFja
 _JkicFQ_n.bY0XExCxYCaXAEeaDtdDyG53TbnW4K48ZOf1iMXaL6d57KUJeH
 RaNCMFVPmxO12Pxv.cfi_XszQBDbtSGRZSzYLRi5rU9H8TT6.jm1OT.1rm9E
 T4FmyvvqBS6RxFeNWjm4_iv5aufX9VtmlxZsvmlVOKOmq3ZQr9qK7fDPKAou
 4MWS1Z7p5vrkTgtzeS1MPouFIt46nbXANEGH5zu5lnPSln9qvmwAsyKndYjx
 hVZKztUyVyig-
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Fri, 10 Dec 2010 02:50:47 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch retracted for this still-born driver. Instead please use superior uasp.c which was recently submitted.


--- On Thu, 10/28/10, Luben Tuikov <ltuikov@yahoo.com> wrote:

> From: Luben Tuikov <ltuikov@yahoo.com>
> Subject: [PATCH] [USB] UAS: Rename urbs by pipe
> To: "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, "Matthew Wilcox" <willy@linux.intel.com>
> Date: Thursday, October 28, 2010, 1:05 PM
> The reason to do this is to
> accommodate sending
> different IU types using the existing
> infrastructure.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/usb/storage/uas.c |   33
> ++++++++++++++++-----------------
>  1 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas.c
> b/drivers/usb/storage/uas.c
> index 17e1820..48dc2b8 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -97,8 +97,8 @@ struct uas_dev_info {
>  };
>  
>  enum {
> -    ALLOC_SENSE_URB   
>     = (1 << 0),
> -    SUBMIT_SENSE_URB    = (1
> << 1),
> +    ALLOC_STATUS_URB    = (1
> << 0),
> +    SUBMIT_STATUS_URB    =
> (1 << 1),
>      ALLOC_DATA_IN_URB    =
> (1 << 2),
>      SUBMIT_DATA_IN_URB    =
> (1 << 3),
>      ALLOC_DATA_OUT_URB    =
> (1 << 4),
> @@ -112,13 +112,12 @@ struct uas_cmd_info {
>      unsigned int state;
>      unsigned int stream;
>      struct urb *cmd_urb;
> -    struct urb *sense_urb;
> +    struct urb *status_urb;
>      struct urb *data_in_urb;
>      struct urb *data_out_urb;
>      struct list_head list;
>  };
>  
> -/* I hate forward declarations, but I actually have a loop
> */
>  static int uas_submit_urbs(struct scsi_cmnd *cmnd,
>             
>     struct uas_dev_info *devinfo, gfp_t
> gfp);
>  
> @@ -204,7 +203,7 @@ static void uas_xfer_data(struct urb
> *urb, struct scsi_cmnd *cmnd,
>      struct uas_cmd_info *cmdinfo = (void
> *)&cmnd->SCp;
>      int err;
>  
> -    cmdinfo->state = direction |
> SUBMIT_SENSE_URB;
> +    cmdinfo->state = direction |
> SUBMIT_STATUS_URB;
>      err = uas_submit_urbs(cmnd,
> cmnd->device->hostdata, GFP_ATOMIC);
>      if (err) {
>         
> spin_lock(&uas_work_lock);
> @@ -360,21 +359,21 @@ static int uas_submit_urbs(struct
> scsi_cmnd *cmnd,
>  {
>      struct uas_cmd_info *cmdinfo = (void
> *)&cmnd->SCp;
>  
> -    if (cmdinfo->state &
> ALLOC_SENSE_URB) {
> -       
> cmdinfo->sense_urb = uas_alloc_sense_urb(devinfo, gfp,
> cmnd,
> -           
>            
>     cmdinfo->stream);
> -        if
> (!cmdinfo->sense_urb)
> +    if (cmdinfo->state &
> ALLOC_STATUS_URB) {
> +       
> cmdinfo->status_urb = uas_alloc_sense_urb(devinfo, gfp,
> cmnd,
> +           
>            
>       cmdinfo->stream);
> +        if
> (!cmdinfo->status_urb)
>             
> return SCSI_MLQUEUE_DEVICE_BUSY;
> -        cmdinfo->state
> &= ~ALLOC_SENSE_URB;
> +        cmdinfo->state
> &= ~ALLOC_STATUS_URB;
>      }
>  
> -    if (cmdinfo->state &
> SUBMIT_SENSE_URB) {
> -        if
> (usb_submit_urb(cmdinfo->sense_urb, gfp)) {
> +    if (cmdinfo->state &
> SUBMIT_STATUS_URB) {
> +        if
> (usb_submit_urb(cmdinfo->status_urb, gfp)) {
>             
> scmd_printk(KERN_INFO, cmnd,
>             
>         "sense urb submission
> failure\n");
>             
> return SCSI_MLQUEUE_DEVICE_BUSY;
>          }
> -        cmdinfo->state
> &= ~SUBMIT_SENSE_URB;
> +        cmdinfo->state
> &= ~SUBMIT_STATUS_URB;
>      }
>  
>      if (cmdinfo->state &
> ALLOC_DATA_IN_URB) {
> @@ -443,7 +442,7 @@ static int uas_queuecommand(struct
> scsi_cmnd *cmnd,
>  
>      BUILD_BUG_ON(sizeof(struct
> uas_cmd_info) > sizeof(struct scsi_pointer));
>  
> -    if (!cmdinfo->sense_urb &&
> sdev->current_cmnd)
> +    if (!cmdinfo->status_urb &&
> sdev->current_cmnd)
>          return
> SCSI_MLQUEUE_DEVICE_BUSY;
>  
>      if (blk_rq_tagged(cmnd->request)) {
> @@ -455,7 +454,7 @@ static int uas_queuecommand(struct
> scsi_cmnd *cmnd,
>  
>      cmnd->scsi_done = done;
>  
> -    cmdinfo->state = ALLOC_SENSE_URB |
> SUBMIT_SENSE_URB |
> +    cmdinfo->state = ALLOC_STATUS_URB |
> SUBMIT_STATUS_URB |
>             
> ALLOC_CMD_URB | SUBMIT_CMD_URB;
>  
>      switch (cmnd->sc_data_direction) {
> @@ -478,8 +477,8 @@ static int uas_queuecommand(struct
> scsi_cmnd *cmnd,
>      err = uas_submit_urbs(cmnd, devinfo,
> GFP_ATOMIC);
>      if (err) {
>          /* If we did
> nothing, give up now */
> -        if
> (cmdinfo->state & SUBMIT_SENSE_URB) {
> -           
> usb_free_urb(cmdinfo->sense_urb);
> +        if
> (cmdinfo->state & SUBMIT_STATUS_URB) {
> +           
> usb_free_urb(cmdinfo->status_urb);
>             
> return SCSI_MLQUEUE_DEVICE_BUSY;
>          }
>         
> spin_lock(&uas_work_lock);
> -- 
> 1.7.0.1
> 
> 
