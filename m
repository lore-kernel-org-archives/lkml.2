Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946007Ab2JYNe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:34:29 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:34519 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945936Ab2JYNeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:34:25 -0400
Message-ID: <50893FC8.1050503@free-electrons.com>
Date: Thu, 25 Oct 2012 15:34:00 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
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
Subject: Re: [PATCH 2/2] arm: mvebu: adding SATA support: dt binding and config
 update
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com> <1351086561-13569-3-git-send-email-gregory.clement@free-electrons.com> <20121024160139.6dbf5e16@skate> <5087F5B9.0@free-electrons.com> <20121025131818.GF18811@titan.lakedaemon.net> <20121025152114.73e69c92@skate>
In-Reply-To: <20121025152114.73e69c92@skate>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 03:21 PM, Thomas Petazzoni wrote:
> Jason,
> 
> On Thu, 25 Oct 2012 09:18:18 -0400, Jason Cooper wrote:
> 
>>> Jason, Andrew, do you want I split this patch as suggested by
>>> Thomas or are you fine with having one single patch?
>>
>> Yes, please make the defconfig changes a separate patch.  Also, please
>> make sure only the minimum is enabled (eq RAID... isn't needed).
> 
> I haven't looked in details at the driver, but is nr-ports = <foo> the
> right way of doing things? We may have platforms were port 0 is not
> used, but port 1 is used, and just a number of ports doesn't allow to
> express this.
> 
> Shouldn't the DT property be
> 
>   ports = <0>, <1>
>   ports = <1>
>   ports = <1>, <3>
> 
> In order to allow to more precisely enabled SATA ports? Or maybe the
> SATA ports cannot be enabled/disabled on a per-port basis, in which
> case I'm obviously wrong here.

The actual implementation of mv_sata.c doesn't work like this. You can
only pass the number of ports supported not the list of the port you
want to support. I've checked in the device tree binding documentation
_and_ also in the code.


> 
> Best regards,
> 
> Thomas
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
