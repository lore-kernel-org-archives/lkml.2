Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1EXMkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:40:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab1EXMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:40:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver
Date: Tue, 24 May 2011 14:40:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        sachi@mistralsolutions.com, "Samuel Ortiz" <sameo@linux.intel.com>,
        "open list" <linux-kernel@vger.kernel.org>,
        "Watkins, Melissa" <m-watkins@ti.com>, Greg KH <greg@kroah.com>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <201105231730.06564.arnd@arndb.de> <7E10264BABCB4C1788DCD9715461BDE8@subhasishg>
In-Reply-To: <7E10264BABCB4C1788DCD9715461BDE8@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241440.34854.arnd@arndb.de>
X-Provags-ID: V02:K0:RBOPofwohX2al2thrzDn/31kL9DIE1z8ZObj5GQrck7
 w5cUUr5ORO7vWz07RcOPRxi1+VTrFLZ8hXdb1Y4ShuAYLZ3hxS
 H3mnpoROk5Ze2a9fGLyt4xyZ8TCO18aNwehZH/w3Vlg9ci6230
 h68WZ07ATK6qdgauGug4G5eSuGVWpEg2bO03ZQCCbq0VP8W2HZ
 +MNgH1wPn1/E+WEoRk8Aw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 May 2011, Subhasish Ghosh wrote:
> Would it be a good approach to first get a basic sensible
> driver into the tree and then work towards improving and
> adjusting for future compatibilities.

The main problem with that is that you cannot really change
user-visible interfaces after the driver is merged. Anything
regarding sysfs attributes and firmware file contents needs
to be fixed. You can however still change in-kernel interfaces
at a later point without problems.

> That way we can gradually build towards the perfect driver
> in steps, rather than digressing far too off suddenly.
> That would be some source of motivation for me too.

You can definitely add the driver to drivers/staging/pruss/,
as the rules for staging drivers are different. I think that
would indeed be helpful at this point. As soon as all
interfaces have stabilized, you can then move the individual
parts to their final location.

Greg maintains the staging drivers, and he can surely point
you to a document describing what is required for a driver.
Mainly, this includes having a patch that adds a single
directory with all the driver files under drivers/staging.
The driver must be able to compile without errors and you need
a TODO file listing the remaining issues that prevent you
from having a non-staging driver.

I think the list will be relatively short, given that you
have made a lot of progress and the driver is now essentially
ready, aside from a few details and the big question of
how the firmware should be configured and loaded.

	Arnd
