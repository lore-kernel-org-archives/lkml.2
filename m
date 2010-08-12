Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914Ab0HLV5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:57:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48512 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab0HLV5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HpxYfTtreJBtHN4s5KkVru2ZB8OBe7VJbXJYfWHoo1ya/zzaAktNfgI6LLyvKnXtby
         ioCudMIzc3eesTRWt7Vtt+y2S7FA+DA8RHzSeiajyJzwzpiL8sGKibNcm4+1e2f6J5lG
         MhLmo8pYIPmveU9qs88uxQtiMEcNMT2mU4KUo=
From: wellsk40@gmail.com
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        durgesh.pattamatta@nxp.com
Subject: RTC: LPC32xx: Introduce RTC driver for the LPC32xx (v3)
Date: Thu, 12 Aug 2010 14:57:23 -0700
Message-Id: <1281650244-9889-1-git-send-email-wellsk40@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for the LPC32xx built-in RTC. This is
a persistent RTC with alarm on it's own power domain and a
dedicated oscillator. UIE emulation is used for *_UIE_* ioctls.

The patch can be pulled from:
	git://git.lpclinux.com/linux-2.6-lpc rtc-lpc32xx_v3

v3 includes updates from the initial review of the RTC driver
and updates from v2. ...Fingers crossed...

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

