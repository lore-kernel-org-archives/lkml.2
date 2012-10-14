Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2JNSDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 14:03:24 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:10533 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2JNSDX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 14:03:23 -0400
X-Authority-Analysis: v=2.0 cv=EOyEIilC c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=DpEkYpXRGzUA:10 a=05ChyHeVI94A:10 a=8nJEP1OIZ-IA:10 a=ayC55rCoAAAA:8 a=nULq49Tkjo8A:10 a=Ln6qw7-ipByP7qF9RfgA:9 a=wPNLvfGTeEIA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507AFE69.70405@cfl.rr.com>
Date: Sun, 14 Oct 2012 14:03:21 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <20121014104138.7e8a9c59@neptune.home> <507A997D.7070508@cfl.rr.com> <20121014130323.06f0225d@neptune.home> <507AEE4A.1000907@cfl.rr.com> <20121014192253.5a7517ef@neptune.home>
In-Reply-To: <20121014192253.5a7517ef@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 01:22 PM, Bruno Prémont wrote:
> Hi Mark,
>
> On Sun, 14 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>> I've taken the EDID data from that service manual. I've looked at the
>> EDID-Howto for how to specify the connector but all I see is:
>>
>> "An EDID data set will only be used for a particular connector,
>>    if its name and a colon are prepended to the EDID name."
>>
>> Where can I find the connector names?
>
> Those are the ones you see under /sys/class/drm/, without the card0-
> prefix.
>
> E.g. on my system I have:
>
> # ls /sys/class/drm/
> card0  card0-DVI-I-1  card0-LVDS-1  card0-VGA-1  controlD64  version
>
> Thus I have connectors "DVI-I-1", "LVDS-1" and "VGA-1" (note that your
> HDMI connector might not be named HDMI-1, if you are not sure which one
> it is, you can look at the files below (edid, enabled, status) which
> should help your find the right connector).
>

Perfect.

>
> In addition, if you rmmod i915 and modprobe it again connectors will get
> increased suffix numbers. So don't expect them to remain the same if you
> have multiple GPUs detected in random order or if you rebind them to
> their driver. (though except during testing or for special systems you
> don't have to worry about this)
>
>> And could I ask if this simple pgm might work to build the file I need?
>
> It looks fine. You can also check the output with hexdump just to
> make sure it looks sane.

Did that and the data looks swapped compared to the array written, but I 
guess that's normal?

> If it's broken kernel will tell you that checksum does not match.
>

So the  check sum is actually already in the data provided by the service 
manual then.

> In any case the (successful) loading of edid should be visible in kernel
> log.
>

I'll be trying this a little later in the day.

Thanks again
Mark


