Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1G3SHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 14:07:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40630 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab1G3SHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 14:07:35 -0400
Message-ID: <4E344863.2080007@lwfinger.net>
Date: Sat, 30 Jul 2011 13:07:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Andreas Hartmann <andihartmann@01019freenet.de>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan> <4E318BD0.40202@lwfinger.net> <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan> <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan> <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan> <4E341DC4.9010107@01019freenet.de> <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2011 12:07 PM, Justin Piszcz wrote:
>
>
> On Sat, 30 Jul 2011, Andreas Hartmann wrote:
>
>> Hi Justin,
>>
>> if you want to test, if the module works stable, run this script for one
>> or two hours. It will stress the driver and the hardware.
>>
>> If it doesn't crash and if the throughput is stable, you can hope, that
>> the driver is ok for daily work.
>>
>>
>> #!/bin/sh
>>
>> dest="server" # set the servername
>>
>> while true ; do
>> netperf -t TCP_MAERTS -H $dest
>> netperf -t TCP_STREAM -H $dest
>> netperf -t TCP_SENDFILE -H $dest
>> done
>>
>>
>> Start the script on the client. On the server start netserver.
>> You get netperf from http://www.netperf.org/netperf/
>>
>>
>> Andreas
>>
>
> Hello Andreas,
>
> Thanks for the suggestion; however, it is crashing repeatedly after about 5-10
> minutes, so it is not needed yet.
>
> Here you go, crash 2:
> http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p1.jpg
> http://home.comcast.net/~jpiszcz/20110730/2630-rt2800usb-crash2p2.jpg

This is likely progress as the crash is in a different place.

The page fault this time is at rt2800usb_get_txwi+0xc. That translates back to 
line 382 of file rt2800usb.c, which says

	if (entry->queue->qid == QID_BEACON)

I have no idea why entry->queue->qid is wrong here, but likely one of the 
smarter people who knows a lot more about the device will be able to figure it out.

Larry
