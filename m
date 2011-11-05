Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1KEMIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 08:08:30 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39796 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1KEMI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 08:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <20111105045156.GA10668@ericsson.com>
References: <1320454450-738-1-git-send-email-a.beregalov@gmail.com>
	<20111105045156.GA10668@ericsson.com>
Date: Sat, 5 Nov 2011 15:08:28 +0300
Message-ID: <CAA1sL1QW+GYHcsE4A-1Oq3UxvKLzNzGw77bBobt_cTr7-5EKFA@mail.gmail.com>
Subject: Re: [PATCH] hwmon: (w83627ehf): fix broken driver init
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pA5C8bnp006520

On 5 November 2011 08:51, Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> Followup - something like
> Â  Â  Â  Â  Â  Â  Â  Â const char *label = NULL;
>
> Â  Â  Â  Â  Â  Â  Â  Â if (data->temp_label)
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â label = data->temp_label[data->temp_src[i]];
>
> Â  Â  Â  Â  Â  Â  Â  Â /* Digital source overrides analog type */
> Â  Â  Â  Â  Â  Â  Â  Â if (label && strncmp(label, "PECI", 4) == 0)
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â data->temp_type[i] = 6;
> Â  Â  Â  Â  Â  Â  Â  Â else if (label && strncmp(label, "AMD", 3) == 0)
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â data->temp_type[i] = 5;
> Â  Â  Â  Â  Â  Â  Â  Â else if ((tmp & (0x02 << i)))
>
> should do it. I am open to better ideas...

Works for me, thanks. You may add my
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
