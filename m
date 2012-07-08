Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2GHAZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 20:25:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33847 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab2GHAZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 20:25:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120707230555.GA29514@kroah.com>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
	<20120630032333.GB3972@kroah.com>
	<CAMbhsRSYL3oE_mbdjyNbV453DddPNUyJBU2eLJhUNaASF1+MtA@mail.gmail.com>
	<20120630041928.GA1816@kroah.com>
	<CAMbhsRRUs1tHQ+DfWzhKE6M47+Rqu0uB4hQgX7d7ZGzaZi9uyw@mail.gmail.com>
	<20120702101057.2a8dd6a6@notabene.brown>
	<CAMbhsRSQhBTxA9g1b4Pc6px4gYcOzn4miOrS6ecdJmOQ+RNSGA@mail.gmail.com>
	<20120707230555.GA29514@kroah.com>
Date: Sat, 7 Jul 2012 17:25:31 -0700
X-Google-Sender-Auth: Qx3aX0dmrs4ExAXCnfl9I1LhxnM
Message-ID: <CAMbhsRSy+cYRDjmYtMdHNUSK4y+vSoEHgKNCaLvvNVopnSvh-Q@mail.gmail.com>
Subject: Re: [PATCH] bcb: Android bootloader control block driver
From: Colin Cross <ccross@android.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: NeilBrown <neilb@suse.de>, Andrew Boie <andrew.p.boie@intel.com>,
        arve@android.com, rebecca@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 7, 2012 at 4:05 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Jul 07, 2012 at 03:39:09PM -0700, Colin Cross wrote:
>> On many (most?) ARM SoCs, the reboot flag is not stored on disk, or
>> anywhere else userspace can access.  It is stored in a power
>> management controller scratch register that survives resets, or a
>> register in an external I2C PMIC, or in internal SoC RAM (I've seen
>> all of these).  For your proposal, every SoC would need a custom API
>> to save the reboot flag somewhere.  For these devices, it clearly
>> makes more sense to use something like the REBOOT2 API, and if we have
>> to use it on some devices, it makes no sense to me to not use it on
>> other devices just because userspace could theoretically handle it.
>
> That's fine, but that is not what this patch did at all.

Yes it is, this patch is exactly what I was referring to in the last
sentence.  This patch implements the REBOOT2 API a device where there
is no available persistent storage inside the SoC and the disk must be
used instead.

> Propose a patch that handles writing to those types of registers and we
> will be glad to review it.

This isn't getting anywhere.  Let me lay out my logic why a driver
that saves reboot reason on disk is useful, and you can tell me where
you disagree.  I'll use specific examples where I can to try to be
less vague.

OMAP4 Panda boards require kernel support for reboot reason, it is
stored in internal RAM ("SAR" RAM) that is also used for
suspend/resume.

Some Tegra boards (Motorola Xoom) require kernel support for reboot
reason, it is stored in the PMIC registers over I2C.

A common API is needed for Panda, Xoom, and a variety of other boards
that use unique storage locations, and the existing REBOOT2 API seems
to me to be designed for this purpose.

Other boards (don't have a specific example here, perhaps Andrew can
provide one) need to store the reboot reason on disk.

Because the REBOOT2 API exists and is required on Panda and Xoom, it
should work on Andrew's board as well.

This patch is an attempt to make the REBOOT2 API work on Andrew's board.

Where do you disagree?
