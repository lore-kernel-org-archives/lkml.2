Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2ADQQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:16:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41820 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab2ADQQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:16:51 -0500
MIME-Version: 1.0
In-Reply-To: <4f034b6c.ypfAbSdXSgMHtfqa%Larry.Finger@lwfinger.net>
References: <4f034b6c.ypfAbSdXSgMHtfqa%Larry.Finger@lwfinger.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Wed, 4 Jan 2012 08:16:29 -0800
Message-ID: <CALSq=BaJSURcKU8RkCxxG=Mht4y04dVefKMESuHmiEdhwzc2Eg@mail.gmail.com>
Subject: Re: [PATCH] rtl8192cu: Fix WARNING on suspend/resume
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, chaoming_li@realsil.com.cn,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, Larry, I didn't see this til it was included in John's mail this morning.

On Tue, Jan 3, 2012 at 10:39 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> +#ifdef CONFIG_PM
> +static int rtl8192cu_usb_suspend(struct usb_interface *pusb_intf,
> +                                pm_message_t message)
> +{
> +       /* Increase usage_count to Save loaded fw across suspend/resume */
> +       atomic_inc(&usage_count);
> +       return 0;
> +}
> +
> +static int rtl8192cu_usb_resume(struct usb_interface *pusb_intf)
> +{
> +       atomic_dec(&usage_count);       /* after resume, decrease usage count */
> +       return 0;
> +}
> +#endif

Based on the warning-fix I submitted yesterday, this probably produces
a warning if CONFIG_PM is set but not CONFIG_PM_SLEEP. My patch was
for an ethernet driver, but iwlwifi and ath5k appear to follow the
same pattern using CONFIG_PM_SLEEP instead of the above.

See: http://www.spinics.net/lists/netdev/msg184717.html for the patch
and http://www.spinics.net/lists/netdev/msg184715.html for the
discussion.

Dan
