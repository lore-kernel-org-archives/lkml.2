Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab1FVTZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:25:43 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42812 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab1FVTZm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:25:42 -0400
MIME-Version: 1.0
In-Reply-To: <1308769914-15440-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	<1308769914-15440-1-git-send-email-sjur.brandeland@stericsson.com>
Date: Wed, 22 Jun 2011 21:25:41 +0200
Message-ID: <BANLkTikq-YnzwOjO=Ob4TjG3P8QJjAnNnQ@mail.gmail.com>
Subject: Re: [RFC PATCHv5 1/7] HSI: hsi: Introducing HSI framework
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Carlos Chinea <carlos.chinea@nokia.com>, sjurbren@gmail.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 9:11 PM, Sjur Brændeland
<sjur.brandeland@stericsson.com> wrote:
>>+/*
>>+ * API for HSI clients
>>+ */
>>+int hsi_async(struct hsi_client *cl, struct hsi_msg *msg);
>>+
>>+/**
>
> I'm pleased to see scatter list support. But is this supported by all HW?
> What is the behavior if HW doesn't support this, will hsi_async fail, or
> is the scatter-list handled 'under the hood'?

I think it's pretty straight-forward even if you have to use PIO (IRQs and
CPU-filling of FIFO). You simply use a memory iterator (sg_miter), so
for example the MMC layer can only handle SGlists and in mmci.c we
use sg_miter_start/next/stop to do this in the PIO case.

If that kind of hardware would ever be fast enough for anyone using
a HSI link is a good question though :-)

Yours,
Linus Walleij
