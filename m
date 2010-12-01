Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0LAC66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:58:58 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51412 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab0LAC65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 21:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P5NovFb5wjcJHeibDUOBxVGFdKE9czXoQd7qknkblBbHjyaTZVWJn3FTwawfFKD8Wg
         yxgdCOcU5JJs/az4dqZWDVEJl0ZZar7XcdqmIsPrTJissVNKtiXZdM7/CFhA+e7dZ9kM
         QXDWTZPKRMTisqwwNbkA6I73RBKK18zo8OtFg=
Subject: Re: [Regression] 2.6.37-rc1: Lenovo T61 mute button does not work
From: Calvin Walton <calvin.walton@gmail.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20101130185303.GI10354@ics.muni.cz>
References: <20101130185303.GI10354@ics.muni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 21:58:44 -0500
Message-ID: <1291172324.14274.33.camel@nayuki>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 19:53 +0100, Lukas Hejtmanek wrote:
> Hi,
> 
> in 2.6.26, mute button worked as expected on my ThinkPad T61 - it toggled
> mute with mixer applet notification. In 2.6.37-rc1, it only mutes without any
> event to any mixer applet.

The mute button on this series of Thinkpads is a little weird (I have an
R61i, which is the same iirc) - the behaviour of the button depends on
the ACPI firmware. With no operating system running, it behaves as a
persistent hardware mute. Windows apparently uses a proprietary driver
to control the volume - part of this functionality has been added to the
Linux thinkpad_acpi driver, but it's not fully enabled yet.

By default on this series of laptops, Linux runs with the ACPI
_OSI(Linux) exported - when the bios of this laptop model sees that it's
running on Linux, it disables the hardware mute functionality and the
mute button acts as a standard keyboard key.

Search your dmesg for lines containing '_OSI(Linux)' - it should say
that a BIOS query was honoured. Make sure you do not have 'acpi_osi="!
Linux"' on your kernel command line.

-- 
Calvin Walton <calvin.walton@gmail.com>

