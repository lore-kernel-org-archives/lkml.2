Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935614Ab2JYL2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:28:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52055 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934929Ab2JYL2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:28:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 1/2] arm: mvebu: increase atomic coherent pool size for armada 370/XP
Date: Thu, 25 Oct 2012 11:27:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com> <1351086561-13569-2-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1351086561-13569-2-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210251127.36960.arnd@arndb.de>
X-Provags-ID: V02:K0:j3x1WX6nzEYk4gMRRun+i+bnaiJSghlrXK4DBfnHYrT
 eawFA8n2bvQ+vk3FLZR+AlnwZrxmFBqSSTCp4ke5Bug8UfW3J0
 HcSn5etjU/BP4FPdyw4XzSeXUTTCWtL/RxYTu+Dt7BWcxAB8uy
 IFueX7Dzu1epsGcd5wUNXw9IWCY6btwCtHoFap7BzMFWEsSYEy
 AChaCMvZzI4XPzkHm9i1Rtx6f2lQLUVTVy55YEeeJJ0XtCbDN7
 0mtP8Z8AY0nhhkfBYNnO862gPqyiC/vdMi1Gvk9I3hFacjxL+A
 tkSEumg0tXr3Cb6qyBNlk0uYs039gq7HnBHXD5l2fK8YVpIe/R
 yqtVcsYXlBB9SYqdd9Ik=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Gregory CLEMENT wrote:
> For Armada 370/XP we have the same problem that for the commit
> cb01b63, so we applied the same solution: "The default 256 KiB
> coherent pool may be too small for some of the Kirkwood devices, so
> increase it to make sure that devices will be able to allocate their
> buffers with GFP_ATOMIC flag"
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Do you know why the ATA driver needs this? I find it surprising that
it's necessary, so I'd like to make sure we're not just working around
a device driver bug here.

	Arnd
