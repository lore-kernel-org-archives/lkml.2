Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0LOQNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:13:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56736 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab0LOQNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:13:06 -0500
Date: Wed, 15 Dec 2010 16:12:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MTD: m25p80: add debugging trace in sst_write()
Message-ID: <20101215161213.GC9937@n2100.arm.linux.org.uk>
References: <1292414372-17085-1-git-send-email-nicolas.ferre@atmel.com> <4D08C1C8.3090100@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D08C1C8.3090100@ru.mvista.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 04:25:28PM +0300, Sergei Shtylyov wrote:
>> +	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %zd\n",
>> +			dev_name(&flash->spi->dev), __func__, "to",
>
>    What's the point of printing "to" as variable? :-)

One valid reason to do this is if you have several formatting strings
all the same.  GCC can merge identical strings together.

So, if you have:

 "%s: %s %s 0x%08x, len %zd", dev_name(), __func__, "to"
 "%s: %s %s 0x%08x, len %zd", dev_name(), __func__, "from"
 "%s: %s %s 0x%08x, len %zd", dev_name(), __func__, "foo"

Then you end up with one long string and three short strings instead of

 "%s: %s to 0x%08x, len %zd", dev_name(), __func__
 "%s: %s from 0x%08x, len %zd", dev_name(), __func__
 "%s: %s foo 0x%08x, len %zd", dev_name(), __func__

which'd be three long strings.
