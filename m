Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1CKViq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:38:46 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36052 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1CKVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:38:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RgYmK6xLHdzfjHW1YOsLfoWtw3+6br0DNJ73hk4rydJ15x5q6VjlOA3LtwBZxi+lwb
         MCoUSj+65Bd/Ti8xdzoMsN+BkL+m0In6e56EIk1qJVKgBRNMdLKKG/+ay8wUSGpXu5GA
         pwUHgcKgiVgTmjj6FSZ943s34LJN7HxxzZjuA=
From: "=?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?=" <jeff.dagenais@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnpol@2ka.mipt.ru
Subject: Add 1-wire (w1) support for DS2408 and multi-slave search in ds1wm
Date: Fri, 11 Mar 2011 16:38:30 -0500
Message-Id: <1299879513-14884-1-git-send-email-dagenaisj@sonatest.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The first patch add generic functionnality to w1_io for Resume Command [A5h]
lots of slaves support. I found it useful for multi-commands/reset workflows
with the same slave on a multi-slave bus.

This DS2408 w1 slave driver is not complete for all the 
features of the chip, but its sufficient if you use it as
a simple IO expander. Enjoy!

The ds1wm had Kconfig dependencies towards ARM && HAVE_CLK. I took them
out since I was using the ds1wm on an x86_64 platform (ds1wm in a FPGA through
pcie) and found them irrelevant.

The clock freq/divisors at the top of ds1wm.c did not have the MSB set to 1.
This bit is CLK_EN which turns the whole prescaler and dividers on. The driver
never mentionned this bit either, so I just included this bit right in the table
entries. I also took the liberty to add a couple of entries to the table. The
spec doesn't explicitely mentions these possibilities but the description and 
examination of the core shows the prescalers & dividers can be used for more
than the table explicitely shows. The table I enlarged still doesn't cover all
possibilities, but it's a good start.

I also made a few tweaks to a couple of the read and write algorithms which 
made sense while I had my head very deep in the ds1wm documentation. We stressed
it a lot with 10+ slaves on the bus, many ds2408, ds2431 and ds2433 at the same
time doing extensive interaction. It proved quite stable in our production 
environment.
