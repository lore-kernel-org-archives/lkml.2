Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935598Ab2JYNVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:21:30 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:34315 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab2JYNV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:21:28 -0400
Date: Thu, 25 Oct 2012 15:21:14 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm: mvebu: adding SATA support: dt binding and
 config update
Message-ID: <20121025152114.73e69c92@skate>
In-Reply-To: <20121025131818.GF18811@titan.lakedaemon.net>
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com>
	<1351086561-13569-3-git-send-email-gregory.clement@free-electrons.com>
	<20121024160139.6dbf5e16@skate>
	<5087F5B9.0@free-electrons.com>
	<20121025131818.GF18811@titan.lakedaemon.net>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

On Thu, 25 Oct 2012 09:18:18 -0400, Jason Cooper wrote:

> > Jason, Andrew, do you want I split this patch as suggested by
> > Thomas or are you fine with having one single patch?
> 
> Yes, please make the defconfig changes a separate patch.  Also, please
> make sure only the minimum is enabled (eq RAID... isn't needed).

I haven't looked in details at the driver, but is nr-ports = <foo> the
right way of doing things? We may have platforms were port 0 is not
used, but port 1 is used, and just a number of ports doesn't allow to
express this.

Shouldn't the DT property be

  ports = <0>, <1>
  ports = <1>
  ports = <1>, <3>

In order to allow to more precisely enabled SATA ports? Or maybe the
SATA ports cannot be enabled/disabled on a per-port basis, in which
case I'm obviously wrong here.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
