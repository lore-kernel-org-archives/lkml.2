Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2BZOaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 09:30:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39392 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2BZOaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 09:30:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kay.sievers@vrfy.org designates 10.68.226.6 as permitted sender) smtp.mail=kay.sievers@vrfy.org; dkim=pass header.i=kay.sievers@vrfy.org
MIME-Version: 1.0
In-Reply-To: <4F49E87B.1050708@gmail.com>
References: <4F49E87B.1050708@gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 26 Feb 2012 15:29:57 +0100
Message-ID: <CAPXgP10q-OqSx4RuS5Pftsvz4q3UfJ2H4keh=g1UbPCNHDocVg@mail.gmail.com>
Subject: Re: Module Load order
To: Prasanna Kumar T S M <prasannatsmkumar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 09:08, Prasanna Kumar T S M
<prasannatsmkumar@gmail.com> wrote:
> Is there any specific module load order in Linux? If there is a GPL
> driver and binary driver for a particular device which will be loaded?
> Is there any logic to load GPL driver built inside the kernel? Or is the
> module search and load is handled by some other component (like udev)
> and not the kernel? Sorry for my ignorance if I have asked this to a
> wrong list.

The order is defined by the link-order of the kernel build, the order
of appearance in the Makefile. The kernel build system creates
compiled-in modules which always have a defined link-order of init
functions. Loadable modules create a file modules.order which is
installed along with the kernel modules. The modules.order file read
by the modprobe tool, and if multiple modules match on the same
hardware alias, the modules are always loaded in the order specified
by that file.

In general, the compiled-in order and the loadable-module order are
always predictable and reflect the order of appearance in the kernel
Makefile.

Out-of-tree/proprietary modules do not hook into that facility and
there is usually no predictable order.

It is possible though, that the out-of-tree module can be installed in
a separate directory in lib/modules and the search order is defined in
/etc/depmod.d/*.conf. Not sure, if that always works, it's something
that usually only enterprise Linux versions use, need and test, and
which might not be available and doesn't get tested in usual
distributions which do not care at all about driver priorities.

Kay
