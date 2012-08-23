Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338Ab2HWHZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:25:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab2HWHZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:25:07 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v4 2/2] input: misc: New USB eBeam input driver.
Date: Thu, 23 Aug 2012 09:23:55 +0200
Message-ID: <1368810.q4rGz16CTW@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.5.0-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1345673514-11575-3-git-send-email-yann.cantin@laposte.net>
References: <1345673514-11575-1-git-send-email-yann.cantin@laposte.net> <1345673514-11575-3-git-send-email-yann.cantin@laposte.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2012 00:11:54 Yann Cantin wrote:
> +static int ebeam_resume(struct usb_interface *intf)
> +{
> +       struct ebeam_device *ebeam = usb_get_intfdata(intf);
> +       struct input_dev *input = ebeam->input;
> +       int result = 0;
> +
> +       mutex_lock(&input->mutex);
> +       if (input->users)
> +               result = usb_submit_urb(ebeam->irq, GFP_NOIO);
> +       mutex_unlock(&input->mutex);
> +
> +       return result;
> +}
> +
> +static int ebeam_reset_resume(struct usb_interface *intf)
> +{
> +       struct ebeam_device *ebeam = usb_get_intfdata(intf);
> +       struct input_dev *input = ebeam->input;
> +       int err = 0;
> +
> +       /* restart IO if needed */
> +       mutex_lock(&input->mutex);
> +       if (input->users)
> +               err = usb_submit_urb(ebeam->irq, GFP_NOIO);
> +       mutex_unlock(&input->mutex);
> +
> +       return err;
> +}

These functions are identical. You should unify them.

	Regards
		Oliver

