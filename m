Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab0HQT7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:59:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48417 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0HQT7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:59:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AKQwJp3o0iRpx5CAKBfQWN+LiQ5hzGc8gKuyGf3LnoepFln7Y4gbuRNzPviKSseIVR
         nFkmuBFoypI0MCggOOhZFbkIu7/1OtDTX7woe1YHAnWdNQtRg+n0E7nF9qbFVbwhssqz
         wMt97PwtoFmR2LuujkGC8HWOedIJERrKNAUJQ=
From: wellsk40@gmail.com
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: RTC: LPC32xx: Introduce RTC driver for the LPC32xx (v4)
Date: Tue, 17 Aug 2010 13:00:33 -0700
Message-Id: <1282075234-18644-1-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the LPC32xx built-in RTC. This is
a persistent RTC with alarm on it's own power domain and a
dedicated oscillator. UIE emulation is used for *_UIE_* ioctls.

The patch can be pulled from:
	git://git.lpclinux.com/linux-2.6-lpc rtc-lpc32xx_v4

v4 includes updates from the initial review of the RTC driver
and updates from v2 and v3

Changes since v3:
	Some RTC macros renamed (and shrunk)
	Fixed RTC key load logic that would cause RTC clock
		to clear to 0 on poweroff or reset if key
		wasn't set elsewhere
	Fixed else case for RTC key check (key present) to
		clear MATCH0 instead on ONSW_MATCH0

Changes since v2:
	RTC register macros now prefixed with LPC32XX_
	Changed alarm_enable type to unsigned char to match
		the type in the struct rtc_wkalrm (enable)
	Set pending flag to correct state in read-alarm
		function
	Change the alarm read failure message to a warning
	Regardless of the state of the alarm enable flag
		passed into set_alarm, the alarm fire value
		is updated. Previously, this was only updated
		when the alarm enable flag was set
	Added braces for else clauses with a single statement
		if the previous if clause had them
	Cleared platform data pointer in rtc structure on
		error and remove

Changes since v1:
	Fixed spaces/tabbing in lpc32xx entry in Kconfig/Makefile
	Remove improper enable for rtc->alarm_enabled
	Removed typecast on rtc structure in irq handler
	Switch to resource managed (devm_) variants of kzalloc
		and other functions in probe. Updated remove
		based on these changes.
	Disabled alarm on probe instead of keeping current register
		settings. No changes for suspend.
	Allowed driver to continue operation without wakeup or
		alarm irq if the rtc irq request failed.
	Relocated module_init and _exit macros to just after it's
		associated function
	Passed a NULL pointer to .driver.pm in platform driver
		structure instead of a list of NULL functions.
	Added MODULE_ALIAS

