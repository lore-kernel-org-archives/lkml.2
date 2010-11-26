Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab0KZT5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:57:30 -0500
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:52894 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952Ab0KZT52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:57:28 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net 3DBDD5A465
Subject: [PATCH 0/5] HID: roccat: Achieve userspace notification on sysfs
 attribute creation
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 20:57:24 +0100
Message-ID: <1290801444.18750.161.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding sysfs attributes to an already created device raises no userland
notification.

Instead of fiddling around in the depths of busses and devices I reuse the
event char device (module hid-roccat). This device gets now created with
a hardware specific class that contains the device attributes.

For this I had to introduce support for binary attributes into struct class.

This is afaik the easiest way to achieve said goal. If these patches get
applied I can upload a new version of my userland tools that is compatible
with old and new drivers in an instant.

As there are quite a couple of unapplied patches flying around, I decided
to base these patches on 2.6.37-rc2 and designed them to contain everything
pending and so make all unapplied patches obsolete.

