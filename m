Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab0J1PtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:49:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54520 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0J1PtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w0nmh0fwsXTald3lmiVCKgy8BfmxNzuB1RrDpupiJ0p47PAeOD5cTwVvjom/pXrAuG
         5FJzjhxnajAw4rrMBJznCnBOs86q0UGlXPP7wADaZfwE1F4KFBnBCVrbqMmLWPFUv17+
         0fOsKqWXVEjIOzg3ulQQ0m2ArdB2VITB7bC1A=
MIME-Version: 1.0
In-Reply-To: <1288124308-14999-2-git-send-email-cyril@ti.com>
References: <1288124308-14999-1-git-send-email-cyril@ti.com>
	<1288124308-14999-2-git-send-email-cyril@ti.com>
Date: Thu, 28 Oct 2010 11:49:06 -0400
Message-ID: <AANLkTi=rDep3jkp2QAjVsgjZ7JQ0ysnse4TARv29fyHm@mail.gmail.com>
Subject: Re: [PATCH v4 01/12] misc: add driver for sequencer serial port
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Cyril Chemparathy <cyril@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/26 Cyril Chemparathy <cyril@ti.com>:

> TI's sequencer serial port (TI-SSP) is a jack-of-all-trades type of serial port
> device.  It has a built-in programmable execution engine that can be programmed
> to operate as almost any serial bus (I2C, SPI, EasyScale, and others).
>
> This patch adds a driver for this controller device.  The driver does not
> expose a user-land interface.  Protocol drivers built on top of this layer are
> expected to remain in-kernel.

Why is this thing in drivers/misc?

drivers/mfd is IMHO the apropriate place for a driver like this, and
the subdrivers should be migrated to use mfd cells and platform
drivers for the subdevices.

All functions and abstractions you create here look suspiciously
lot like other MFD devices.

But please, beat me up if I'm wrong!

Yours,
Linus Walleij
