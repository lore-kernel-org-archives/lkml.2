Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2HQK5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:57:55 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:32915 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030992Ab2HQK5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:57:51 -0400
MIME-Version: 1.0
Date: Fri, 17 Aug 2012 13:57:49 +0300
X-Google-Sender-Auth: 67F7A-B01ndHTNg9jhb5t1VK28o
Message-ID: <CAOJsxLEb+J=p8Kd782VWPm0ft3D9ujOnV0x_Av+fjWp6QiTHQQ@mail.gmail.com>
Subject: [PROBLEM] thinkpad_acpi: unhandled HKEY event 0x6040
From: Pekka Enberg <penberg@kernel.org>
To: ibm-acpi-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm seeing this when I dock a Thinkpad X220 laptop:

[ 3129.616279] thinkpad_acpi: unknown possible thermal alarm or
keyboard event received
[ 3129.616297] thinkpad_acpi: unhandled HKEY event 0x6040
[ 3129.616298] thinkpad_acpi: please report the conditions when this
event happened to ibm-acpi-devel@lists.sourceforge.net
[ 3129.616949] thinkpad_acpi: undocked from hotplug port replicator
[ 3129.617065] ACPI: \_SB_.GDCK - undocking
[ 3144.184916] ACPI: \_SB_.GDCK - docking
[ 3144.185204] ACPI: Unable to dock!

and the monitor doesn't come up.

I'm currently running a stock Fedora kernel:

[penberg@tux ~]$ uname -a
Linux tux 3.3.8-1.fc16.x86_64 #1 SMP Mon Jun 4 20:49:02 UTC 2012
x86_64 x86_64 x86_64 GNU/Linux

but looking at drivers/platform/x86/thinkpad_acpi.c in Linus' tree, the event
is not handled there either:

        TP_HKEY_EV_UNK_6040             = 0x6040, /* Related to AC change?
                                                     some sort of APM hint,
                                                     W520 */

Help!

                        Pekka
