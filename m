Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab0IZOEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 10:04:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36053 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0IZOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 10:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=teMTSrs7F4nJmxuHnd/+2WVNVf+EloqIBM3XqApvXDwlHtZ7Niu/lb+5LVdbZGev1y
         Cng7RtKA9qUeDj9MiVnuDvslnwdHpT8QTzgGASCbEsxU63hZmFv025Xh8zVwwxYYnRoH
         IsCA5rEQU+PYotsTupBGgfPpgTbgOtFiO1wDo=
Date: Sun, 26 Sep 2010 16:06:29 +0200
From: Lutz Ballaschke <vegan.grindcore@googlemail.com>
To: Giel van Schijndel <me@mortis.eu>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/3] watchdog: add f71862fg support
Message-ID: <20100926140629.GA2150@kreios.titan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

this patch adds support for the watchdog included in Fintek f71862fg
Super-I/O chip to the f71808e_wdt driver and adds WDIOC_GETTIMELEFT
ioctl which i found very helpful. 

This patch comes in three parts:
1/3: add f71862fg support
2/3: add WDIOC_GETTIMELEFT ioctl and helper function
3/3: clean up/replace some magic numbers/constants

changelog
---------

PATCHv2:
 * module parameter for WDTRST# pin configuration added
 * checking/printk of WDTRST# pin config 
 * removing int typecast

NOTE: due to an unprobable chain of events (sort of ineffable BOB stuff)
there wasn't posted more than PATCHv2 0/3 - sorry for the confusion.


PATCHv3:
 * pin parameter check and pin configuration moved to helper function
 * cleaned up a little more

Furthermore i was thinking about modifying the WDIOC_GETTIMELEFT
helper function since it simply returns the content of the WDT timer 
register without regarding whether the driver runs in minute-mode or not
(thanks to Giel for pointing that out). This means if the driver is loaded 
with a timeout of >255 seconds (and switches to minute-mode) WDIOC_GETTIMELEFT
ioctl returns minutes instead of seconds and thus doesn't comply with 
watchdog-api (e.g. ioctl returns 6(min) not 360(sec)). It might be 
confusing if one loads the driver with a timeout of let's say 360 seconds 
and gets 6 minutes returned by ioctl. But imho it's not very accurate to
return a value of seconds if the wdt doesn't count in seconds. That might
be even more confusing. This inconsistency on the part of the hardware 
maybe can't get satisfyingly compensated by the driver. So i'd prefer the 
most simple solution.

---------

 drivers/watchdog/f71808e_wdt.c |   78 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 72 insertions(+), 6 deletions(-)


Thanks for help and comments,

Lutz Ballaschke

