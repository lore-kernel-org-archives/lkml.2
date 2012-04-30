Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab2D3Rbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:31:40 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43558 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756381Ab2D3Rbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:31:38 -0400
MIME-Version: 1.0
Date: Mon, 30 Apr 2012 18:31:37 +0100
Message-ID: <CAEqHmAstczdi2seTHFE0-jLK9fJaKosHjJyo4AJ7E9UKYBrVsg@mail.gmail.com>
Subject: Linux 3.4-rc2 register mapping and paging on I2C device.
From: dd diasemi <dd.diasemi@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Anthony Olech <Anthony.Olech@diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

I need to implement a I2C MFD driver that requires register page
switching. It is not supported by regmap currently and requires
additional effort to make it clean. What is the best (most clean) way
of implementing a driver with register page switching?

I have come up with few alternatives:
1. Write the driver without regmap, with separate I2C routines.
2. After a call to devm_regmap_init_i2c(), exchange regmap.bus.read,
regmap.bus.write and regmap.bus.gather_write with specific handlers
(supporting register page switching). Those handlers would call
original I2C bus handlers indirectly, by passing altered registers.
3. Update regmap API to enable support for register page switching.

Let me know what you think,

many thanks,

Krystian
