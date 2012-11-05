Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab2KEFet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:34:49 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52256 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2KEFej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:34:39 -0500
MIME-Version: 1.0
In-Reply-To: <1352091026-5441-1-git-send-email-huawei.yang@gmail.com>
References: <1352091026-5441-1-git-send-email-huawei.yang@gmail.com>
Date: Mon, 5 Nov 2012 11:04:39 +0530
Message-ID: <CAPEGOOKZTxR725UtoeEXDeCaS4RgvBHfymJYzknaopwsoWMh1A@mail.gmail.com>
Subject: Re: [PATCH 1/1] staging: usbip: remove an unnecessary lock in
 usbip_event_happened. The variable "happened" is local. So I think there is
 no need to lock here.
From: Prashant Shah <kerneldev100@gmail.com>
To: Harvey Yang <harvey.huawei.yang@gmail.com>
Cc: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>         int happened = 0;
>
> -       spin_lock(&ud->lock);
>         if (ud->event != 0)
>                 happened = 1;
> -       spin_unlock(&ud->lock);
>
>         return happened;

I am guessing locking was intended to protect ud->event along with
happened so that (checking the value of ud->event and setting value of
happened) was atomic.

return ud->event != 0 ? 1 : 0;

Regards.
