Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2CMNZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 09:25:07 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34200 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952Ab2CMNZF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 09:25:05 -0400
MIME-Version: 1.0
Date: Tue, 13 Mar 2012 09:25:03 -0400
X-Google-Sender-Auth: qwZ_ef0yUujZ7rF62zKynKvC1uA
Message-ID: <CAOvdn6W+-w2wYdqLCMHUDJr0WDXn3ssBvWnvvZy7Ni_FG2C0jQ@mail.gmail.com>
Subject: 3.2.10 stable build failures?
From: Ben Guthro <ben@guthro.net>
To: greg@kroah.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello - I merged the 3.2.10 stable patch set that you pushed yesterday
into my tree, but am seeing build failures that
WM1811_JACKDET_MODE_MASK is undeclared.

This looks like it originated with the following commit:

commit 315e73b400c9a287a53efb5f857d308589674ac5
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Mon Feb 20 21:32:32 2012 +0000

    mfd: Test for jack detection when deciding if wm8994 should suspend

    commit e7c248a049c2aac21bded0b0722caee6f0e57256 upstream.

    The jack detection on WM1811 is often required during system suspend, add
    it as another check when deciding if we should suspend.

    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>



I've grepped the entire 3.2.10 source tree for
WM1811_JACKDET_MODE_MASK - but have only found the occurence in the if
statement introduced in the above changeset


In the mainline tree, "git blame" says this was introduced in the
following changeset to
include/linux/mfd/wm8994/registers.h

commit af6b6fe41c4bc9e7933d66bbbf5106e0e7e6e484
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Wed Nov 30 20:32:05 2011 +0000

    ASoC: Implement support for WM1811A jack detection

    The WM1811A features an advanced low power accessory detection subsystem
    which allows the device to be maintained in a very low power state while
    the system is idle without sacrificing any accessory detection features.

    Implement software support for this, automatically managing the power
    configuration of the device depending on the detected accessory.

    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>



Would you recommend me backporting that changeset from mainline, or
reverting the offending one?


- Ben Guthro
