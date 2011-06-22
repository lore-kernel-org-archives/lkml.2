Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab1FVThr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:37:47 -0400
Received: from pmx.vmail.no ([193.75.16.11]:60010 "EHLO pmx.vmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab1FVThp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:37:45 -0400
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Carlos Chinea <carlos.chinea@nokia.com>, sjurbren@gmail.com
Cc: Andras Domokos <andras.domokos@nokia.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC PATCHv5 4/7] HSI: hsi_char: Add HSI char device driver
Date: Wed, 22 Jun 2011 21:37:44 +0200
Message-Id: <1308771464-15980-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1307713124-3946-5-git-send-email-carlos.chinea@nokia.com>
References: <1307713124-3946-5-git-send-email-carlos.chinea@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Carlos,

...
>+static ssize_t hsc_read(struct file *file, char __user *buf, size_t len,
>+						loff_t *ppos __maybe_unused)
>+{
...
>+	ret = hsi_async_read(channel->cl, msg);
>+
>+	ret = wait_event_interruptible(channel->rx_wait,
>+					!list_empty(&channel->rx_msgs_queue));
...

>+}
>+
>+static ssize_t hsc_write(struct file *file, const char __user *buf, size_t len,
>+						loff_t *ppos __maybe_unused)
>+{
>+	ret = hsi_async_write(channel->cl, msg);
>+	if (ret < 0)
>+		goto out;
>+
>+	ret = wait_event_interruptible(channel->tx_wait,
>+					!list_empty(&channel->tx_msgs_queue));

I would really like to see support for non-blocking read/write operation here.

...
>+
>+static const struct file_operations hsc_fops = {
>+	.owner		= THIS_MODULE,
>+	.read		= hsc_read,
>+	.write		= hsc_write,
>+	.unlocked_ioctl	= hsc_ioctl,
>+	.open		= hsc_open,
>+	.release	= hsc_release,
>+};

No poll?
Currently we do bulk read/write operations upon modem-crash or firmware upload,
and would perfeer to be able do asynchronous IO (select/poll) in order to
receive other system events or timeouts during HSI bulk transfers.

Regards,
Sjur
