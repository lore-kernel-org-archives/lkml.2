Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1EGUWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 16:22:49 -0400
Received: from smtpout05.highway.telekom.at ([195.3.96.77]:60847 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752067Ab1EGUWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 16:22:48 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-kernel@vger.kernel.org, tiwai@suse.de
Subject: Re: i915/kms/backlight-combo mode problem
Date: Sat, 7 May 2011 22:22:40 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.5; KDE/4.6.2; x86_64; ; )
Cc: "Joey Lee" <jlee@novell.com>, chris@chris-wilson.co.uk,
        dri-devel@lists.freedesktop.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <4DC47937020000230002C446@novprvlin0050.provo.novell.com> <201105061823.07083@rk-nord.at>
In-Reply-To: <201105061823.07083@rk-nord.at>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105072222.41807@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Melchior FRANZ -- Friday 06 May 2011:
> last patch prevents the backlight from being turned off, but it also
> breaks the brightness adjustment keys at runtime with acpi_osi=Linux.

It has turned out that acpi key events seem to be handled correctly
and even the state of /sys/class/backlight/acer-wmi/brightness is
updated accordingly. The only problem is that this maintained
brightness state isn't applied to the actual backlight. It remains
at highest level. Google pointed me to this workaround for another
Acer notebook:

  https://help.ubuntu.com/community/AspireTimeline/Fixes#Alternative%20fix%20for%2010.10

This uses the acpid to write the brightness value to the display
using setpci. And this works on my notebook as well (Acer Travelmate
5735Z-452G32Mnss). Not pretty but better than nothing. Is Acer
not able to build proper notebooks? Or is it a kernel bug?

m.
