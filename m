Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab1FWJR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:17:28 -0400
Received: from smtp.nokia.com ([147.243.1.48]:56975 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759007Ab1FWJR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:17:26 -0400
Subject: Re: [RFC PATCHv5 4/7] HSI: hsi_char: Add HSI char device driver
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Sjur =?ISO-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: sjurbren@gmail.com, Andras Domokos <andras.domokos@nokia.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1308771464-15980-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1307713124-3946-5-git-send-email-carlos.chinea@nokia.com>
	 <1308771464-15980-1-git-send-email-sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 12:12:58 +0300
Message-ID: <1308820378.27256.2773.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-06-22 at 21:37 +0200, ext Sjur Brændeland wrote:
> Hi Carlos,
> 
> ...
> >+static ssize_t hsc_read(struct file *file, char __user *buf, size_t len,
> >+						loff_t *ppos __maybe_unused)
> >+{
> ...
> >+	ret = hsi_async_read(channel->cl, msg);
> >+
> >+	ret = wait_event_interruptible(channel->rx_wait,
> >+					!list_empty(&channel->rx_msgs_queue));
> ...
> 
> >+}
> >+
> >+static ssize_t hsc_write(struct file *file, const char __user *buf, size_t len,
> >+						loff_t *ppos __maybe_unused)
> >+{
> >+	ret = hsi_async_write(channel->cl, msg);
> >+	if (ret < 0)
> >+		goto out;
> >+
> >+	ret = wait_event_interruptible(channel->tx_wait,
> >+					!list_empty(&channel->tx_msgs_queue));
> 
> I would really like to see support for non-blocking read/write operation here.
> 

Non-blocking support will not be supported in hsi_char.

> ...
> >+
> >+static const struct file_operations hsc_fops = {
> >+	.owner		= THIS_MODULE,
> >+	.read		= hsc_read,
> >+	.write		= hsc_write,
> >+	.unlocked_ioctl	= hsc_ioctl,
> >+	.open		= hsc_open,
> >+	.release	= hsc_release,
> >+};
> 
> No poll?

We did have some "kind" of support for poll in previous versions, but we
did not honor properly the poll expected behavior, as we always need to
"block" waiting for the complete callback to be called. At least for
reads this was an issue.

However to compensate this, we are planning to add AIO support in the
future, which maps a lot better into the hsi behavior.

> Currently we do bulk read/write operations upon modem-crash or firmware upload,
> and would perfeer to be able do asynchronous IO (select/poll) in order to
> receive other system events or timeouts during HSI bulk transfers.
> 


Br,
-- 
Carlos Chinea <carlos.chinea@nokia.com>

