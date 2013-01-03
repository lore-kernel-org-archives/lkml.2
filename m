Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab3ACJeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:34:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3ACJeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:34:03 -0500
Date: Thu, 3 Jan 2013 10:33:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, hsweeten@visionengravers.com
Subject: Re: [PATCH 1/3] HID: introduce helper for hid_driver boilerplate
In-Reply-To: <201212171526.55969.hartleys@visionengravers.com>
Message-ID: <alpine.LNX.2.00.1301031033530.27348@pobox.suse.cz>
References: <201212171526.55969.hartleys@visionengravers.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, H Hartley Sweeten wrote:

> Introduce the module_hid_driver macro which is a convenience macro
> for HID driver modules similar to module_usb_driver. It is intended
> to be used by drivers with init/exit sections that do nothing but
> register/unregister the HID driver.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> ---
>  include/linux/hid.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 7330a0f..d6c71a6 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -700,6 +700,18 @@ extern int __must_check __hid_register_driver(struct hid_driver *,
>  
>  extern void hid_unregister_driver(struct hid_driver *);
>  
> +/**
> + * module_hid_driver() - Helper macro for registering a HID driver
> + * @__hid_driver: hid_driver struct
> + *
> + * Helper macro for HID drivers which do not do anything special in module
> + * init/exit. This eliminates a lot of boilerplate. Each module may only
> + * use this macro once, and calling it replaces module_init() and module_exit()
> + */
> +#define module_hid_driver(__hid_driver) \
> +	module_driver(__hid_driver, hid_register_driver, \
> +		      hid_unregister_driver)
> +
>  extern void hidinput_hid_event(struct hid_device *, struct hid_field *, struct hid_usage *, __s32);
>  extern void hidinput_report_event(struct hid_device *hid, struct hid_report *report);
>  extern int hidinput_connect(struct hid_device *hid, unsigned int force);

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
