Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab2ANVKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 16:10:09 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52266 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756697Ab2ANVKH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 16:10:07 -0500
MIME-Version: 1.0
Date: Sat, 14 Jan 2012 23:10:05 +0200
Message-ID: <CANOLnONB5m5iNbWy1=7WWN7T76S1vACbWtJu+KGyhqw2-cA3sw@mail.gmail.com>
Subject: bq27x00_battery status report issue
From: Grazvydas Ignotas <notasas@gmail.com>
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After 270968c0984ae "bq27x00_battery: Fix reporting status value for
bq27500 battery" status doesn't seem to be reported correctly when the
battery is close to fully charged state. It reports "Not charging"
while in fact there is >130mA current flowing to the battery according
to current_now.

This status report seems to be based on CHG bit in status register,
but looking at the datasheet the description says "(Fast) charging
allowed", which I guess means that the chip recommends charging and
not that charging is actually going on? If you check the bit while
battery is discharging and it's not full, the bit is also set.


-- 
Gražvydas
