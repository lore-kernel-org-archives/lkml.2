Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2HEX2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 19:28:03 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34182 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab2HEX2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 19:28:01 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: regulator: Policy for setting current limits
Date: Mon, 6 Aug 2012 01:27:56 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208060127.57074.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hit a problem when setting a current limit and am not sure whose fault it is 
(i.e. which component to change). Therefore I'd appreciate a pointer in the 
right direction.

After the recent changes the gpio-regulator always selects the minimal value 
to set. The gpio-vbus driver sets it's current limits as 0 - x mA (x = 100, 
500). Therefore if 500mA are the upper limit but the regulator also supports 
lower values, these lower values always get selected (100mA in my case).
In contrast pda_power sets the target current as both lower and upper limit.

So the question is, what is the correct way to handle this:

(a) let the gpio-regulator select the max current (in contrast to the minimum 
voltage)
(b) change gpio-vbus to also use the target current as min and max value
(c) something else


Thanks
Heiko
