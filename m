Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab1IWXFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:05:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31269 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1IWXFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:05:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=pbnKwtUqsU7lRdDMIvrIz7sOpltEqrHp9Ea2+RRIljA8iwfDbTnTrultWylUyb6GG
	qX1lnQpqnMIC4fRzBycAA==
Date: Fri, 23 Sep 2011 16:04:45 -0700
From: Andrew Morton <akpm@google.com>
To: Austin Boyle <Austin.Boyle@Aviatnet.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.39-rc7] RTC: rtc-ds1307 EEPROM support for ds1388
 chip
Message-Id: <20110923160445.68c3098e.akpm@google.com>
In-Reply-To: <1312151457.24642.5747.camel@pc786-ubu.gnet.global.vpn>
References: <1306127917.3071.32.camel@pc786-ubu.gnet.global.vpn>
	<1308024897.2992.39.camel@pc786-ubu.gnet.global.vpn>
	<20110722145451.78390257.akpm@linux-foundation.org>
	<1312151457.24642.5747.camel@pc786-ubu.gnet.global.vpn>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Aug 2011 10:30:57 +1200
Austin Boyle <Austin.Boyle@Aviatnet.com> wrote:

> [PATCH 3.0] RTC: EEPROM support for DS1388
> 
> This patch adds support for different sized NVRAM, such as
> the 512 bytes of EEPROM on the DS1388 chip.

This patch is causing problems in today's linux-next, with x86_64 allmodconfig:

drivers/rtc/rtc-ds1307.c: In function 'ds1307_probe':
drivers/rtc/rtc-ds1307.c:796: warning: passing argument 1 of 'i2c_smbus_read_i2c_block_data' from incompatible pointer type
include/linux/i2c.h:98: note: expected 'const struct i2c_client *' but argument is of type 'struct i2c_client **'
drivers/rtc/rtc-ds1307.c:949: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'

Please take a look?  You'll need %z for the printk warning.
