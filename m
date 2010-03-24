Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0CXQUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:20:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0CXQUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:20:42 -0400
Message-ID: <4BAA3BEB.6010902@redhat.com>
Date: Wed, 24 Mar 2010 17:20:59 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Giel van Schijndel <me@mortis.eu>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] [RFC] hwmon: f71882fg: Add watchdog API for F71808E
 and F71889
References: <20100323141718.GA23172@salidar.me.mortis.eu>	<1269385936-3440-1-git-send-email-me@mortis.eu>	<1269385936-3440-2-git-send-email-me@mortis.eu>	<1269385936-3440-3-git-send-email-me@mortis.eu>	<1269385936-3440-4-git-send-email-me@mortis.eu>	<4BA9CF57.4030504@redhat.com>	<20100324093651.GG6368@salidar.me.mortis.eu>	<4BA9EA5C.9060506@redhat.com>	<20100324153550.GK6368@salidar.me.mortis.eu> <20100324155151.2482952f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100324155151.2482952f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/24/2010 04:51 PM, Alan Cox wrote:
>> hold on the SIO port range. This would thus interfere with the operation
>> of the f71882fg driver. I.e. it would prevent the device probing stage
>> from working, thus preventing it from loading *after* my in-development
>> watchdog driver.
>
> There are two ways to deal with that really
>
> 1. Add a multi-function driver - it finds the chip and claims the port
> regions and then provides methods for locked access to them as well as
> creating other device instances that the drivers map to (probably platform
> devices ?) which in turn trigger the loading/binding of the relevant low
> level devices.
>
> 2. Fix the kernel request_resource stuff to support a sleeping non
> exclusive resource so request/free of regions can be used as a resource
> semaphore by co-operative devices.
>
> #2 is actually not hard but when I did the patch originally it then
> wasn't needed by the driver I had in mind for other reasons.
>
> See http://groups.google.com/group/linux.kernel/msg/1425fc2aad32e6ea
>
> Maybe its worth resurrecting ?
>

Or, a bit more specific solution would be to resurrect the superio lock
coordinator patches, which were written (but never merged) 2 years ago
to solve exactly this problem:
http://lists.lm-sensors.org/pipermail/lm-sensors/2008-July/023743.html

Regards,

Hans
