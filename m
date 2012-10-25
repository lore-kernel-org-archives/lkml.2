Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946028Ab2JYN5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:57:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37773 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab2JYN5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:57:22 -0400
Message-ID: <50894534.2000602@gmail.com>
Date: Thu, 25 Oct 2012 08:57:08 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jon Masters <jcm@redhat.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/2] arm: mvebu: adding SATA support: dt binding and config
 update
References: <1351086561-13569-1-git-send-email-gregory.clement@free-electrons.com> <1351086561-13569-3-git-send-email-gregory.clement@free-electrons.com> <20121024160139.6dbf5e16@skate> <5087F5B9.0@free-electrons.com> <20121025131818.GF18811@titan.lakedaemon.net> <20121025152114.73e69c92@skate> <50893FC8.1050503@free-electrons.com>
In-Reply-To: <50893FC8.1050503@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 08:34 AM, Gregory CLEMENT wrote:
> On 10/25/2012 03:21 PM, Thomas Petazzoni wrote:
>> Jason,
>>
>> On Thu, 25 Oct 2012 09:18:18 -0400, Jason Cooper wrote:
>>
>>>> Jason, Andrew, do you want I split this patch as suggested by
>>>> Thomas or are you fine with having one single patch?
>>>
>>> Yes, please make the defconfig changes a separate patch.  Also, please
>>> make sure only the minimum is enabled (eq RAID... isn't needed).
>>
>> I haven't looked in details at the driver, but is nr-ports = <foo> the
>> right way of doing things? We may have platforms were port 0 is not
>> used, but port 1 is used, and just a number of ports doesn't allow to
>> express this.
>>
>> Shouldn't the DT property be
>>
>>   ports = <0>, <1>
>>   ports = <1>
>>   ports = <1>, <3>
>>
>> In order to allow to more precisely enabled SATA ports? Or maybe the
>> SATA ports cannot be enabled/disabled on a per-port basis, in which
>> case I'm obviously wrong here.
> 
> The actual implementation of mv_sata.c doesn't work like this. You can
> only pass the number of ports supported not the list of the port you
> want to support. I've checked in the device tree binding documentation
> _and_ also in the code.

Is that a statement about the driver or the h/w? It does not matter what
the driver does. If the h/w can support skipping a port, then the dts
should allow that.

A bitmask would be most appropriate here (and matches how AHCI does the
equivalent).

Rob

