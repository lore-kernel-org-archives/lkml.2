Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab1GDSmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 14:42:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53400 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1GDSmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 14:42:12 -0400
MIME-Version: 1.0
From: Wim Heirman <wim@heirman.net>
Date: Mon, 4 Jul 2011 20:41:51 +0200
X-Google-Sender-Auth: fxiYfYiEvb7Qf_bAb5X_uBMpUjI
Message-ID: <CALGf=fGhAM2sgGBv-Lz8oiV31Y92WD7rnpPpx6uwJY0v27AXBg@mail.gmail.com>
Subject: cpufreq userspace not listening
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to set the frequencies on a quad core Nehalem processor
(Xeon X5550). I want all four cores to have a different, fixed
frequency (I'm doing research on load-balancing applications). For
this processor type,
/sys/devices/system/cpu/cpu*/cpufreq/affected_cpus lists only a single
core so I would assume that, when using the userspace governor and
writing different frequencies to scaling_setspeed, it should work.

Yet when I try this, cpuinfo_cur_freq often reports a different
frequency than the assigned one. Concretely, when loading the system,
cores seem to throttle up to the maximum frequency assigned to any of
the cores in the same package, rather than sticking to their own
assigned frequency.

Are there any settings I may have missed? Is it at all possible to use
different frequencies within a socket? scaling_driver is acpi-cpufreq,
kernel version 2.6.38 (Ubuntu 11.04).

Thanks,
Wim
