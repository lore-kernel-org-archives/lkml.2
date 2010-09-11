Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0IKAKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 20:10:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61214 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab0IKAJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 20:09:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=axxL0WbeRT10vzXewdL35HKmV19HyUJGNuoN+f/tRhXKDG34KslkDd1IIGuZ55KRXh
         nBgqIPtaL/eTzrzcA+z78VKYNLrGYvlKcY7Lqo4VOfmTqov0W3WoRH4W3T2NAcRg70dJ
         RBEI0ub3q25t7W6ZGBfx4gMbYCamjqt8FQaVE=
Date: Sat, 11 Sep 2010 02:11:48 +0200
From: Lutz Ballaschke <vegan.grindcore@googlemail.com>
To: Giel van Schijndel <me@mortis.eu>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/3] watchdog: add f71862fg support
Message-ID: <20100911001148.GB13116@kreios.titan>
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

Differences to PATCHv1 are
 * module parameter for WDTRST# pin configuration added
 * checking/printk of WDTRST# pin config 
 * removing int typecast

This patch comes in three parts:
1/3: add f71862fg support
2/3: add WDIOC_GETTIMELEFT ioctl and helper function
3/3: clean up/replace some magic numbers/constants

Thanks for the comments,

Lutz Ballaschke

 drivers/watchdog/f71808e_wdt.c |   66 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 61 insertions(+), 5 deletions(-)
