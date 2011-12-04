Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1LDLRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 06:17:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64142 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1LDLRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 06:17:18 -0500
MIME-Version: 1.0
Date: Sun, 4 Dec 2011 12:17:17 +0100
Message-ID: <CAGPN=9SQraacGpNJTtsA4NUk8Re1neJaDt42u8HFw8Hg-+n5BQ@mail.gmail.com>
Subject: xhci_hcd: Runtime PM causes port to inactivate
From: Patrik Kullman <patrik.kullman@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issuing

echo auto > /sys/bus/pci/devices/0000:03:00.0/power/control

on my Asus Zenbook UX31E with a

03:00.0 USB Controller: Fresco Logic Device 1009 (rev 02)

causes its USB3-port to become mostly disabled.

It does have a "Charger+" feature that allows it to charge cellphones
etc even when turned off, and this feature works when power control is
in "auto" mode.

In all other aspects, the port is turned off. It doesn't react to
devices being inserted.

This does not feel like the desired behavior.

Also, suspend does not work without unbinding the xhci_hcd module, not
sure if that is related.
Computer will not suspend/resume unless the following script is used
in /etc/pm/sleep.d:
https://help.ubuntu.com/community/AsusZenbook#Suspend.2C_Hibernate.2C_Shut-down_and_Reboot

This behavior has not changed between 3.0 and 3.2-rc4+ that I've tried today.
