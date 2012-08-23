Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab2HWHSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:18:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab2HWHSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:18:44 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v4 2/2] input: misc: New USB eBeam input driver.
Date: Thu, 23 Aug 2012 08:54:55 +0200
Message-ID: <5832321.EK5PCgIIzt@linux-lqwf.site>
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
> +       /* input final setup */
> +       err = input_register_device(ebeam->input);
> +       if (err) {
> +               dev_dbg(&intf->dev,
> +                       "%s - input_register_device failed, err: %d\n",
> +                       __func__, err);
> +               goto out_free_urb;
> +       }
> +
> +       ebeam_setup_input(ebeam, input_dev);
> +
> +       /* usb final setup */
> +       usb_set_intfdata(intf, ebeam);

Hi,

this looks like a classic race. You initialize the device after you
register it. However, it may be used at that time.

	Regards
		Oliver

