Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0EFFpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 01:45:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41941 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0EFFpE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 01:45:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:from:date:
	x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=YKe67SZy9ETAPZeaQGaEdxXCyF5hMNbEdz66bpDvdazfgrRX3+SAXuTrqG6lryQvx
	hYT1Qyd5vPx6HMDn/ipDw==
MIME-Version: 1.0
In-Reply-To: <1273122377-12137-1-git-send-email-rkc@chromium.org>
References: <1273122377-12137-1-git-send-email-rkc@chromium.org>
From: Rahul Chaturvedi <rkc@chromium.org>
Date: Wed, 5 May 2010 22:44:41 -0700
X-Google-Sender-Auth: 364026482b0f6e2d
Message-ID: <t2w1cd529021005052244sdefc0247n8d0b40a6612a3438@mail.gmail.com>
Subject: Re: [PATCH] CHROMIUM: acerhdf: fix bug when running on Qemu
To: peter@piie.net, linux-kernel@vger.kernel.org
Cc: msb@chromium.org, Rahul Chaturvedi <rkc@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, the CHROMIUM in the subject is just used for internal bookeeping
for patches not yet accepted upstream.

On Wed, May 5, 2010 at 22:06, Rahul Chaturvedi <rkc@chromium.org> wrote:
> Driver didn't verify the pointers in which it got product information
> back from DMI; on QEMU one of the pointers came back null,
> which made the driver crash and subsequently caused a kernel panic.
>
> Signed-off-by: Rahul Chaturvedi <rkc@chromium.org>
> ---
>  drivers/platform/x86/acerhdf.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 4d922e4..e8ee3b2 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -500,6 +500,11 @@ static int acerhdf_check_hardware(void)
>        product = dmi_get_system_info(DMI_PRODUCT_NAME);
>
>
> +       if (!vendor || !version || !product) {
> +               pr_err("error getting hardware information");
> +               return -EINVAL;
> +       }
> +
>        pr_info("Acer Aspire One Fan driver, v.%s\n", DRV_VER);
>
>        if (force_bios[0]) {
> --
> 1.7.0.1
>
>
