Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1HCVF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 17:05:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47625 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1HCVFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 17:05:52 -0400
Message-ID: <4E39B82C.2010108@lwfinger.net>
Date: Wed, 03 Aug 2011 16:05:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: Linux Wireless USB-Stick Question
References: <alpine.DEB.2.02.1108031550100.4278@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1108031550100.4278@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 02:53 PM, Justin Piszcz wrote:
> Hi,
>
> Under Windows, you can achieve 10-15MiB/s..
>
> Under Linux, even with 150mbps USB wireless adapters, the max never appears to
> go above > 3-4MiB/s, to work around this, order more USB-wifi ticks and run them
> in parallel far away from each other with USB
> extenders:
>
> box1:
> -------------
> wlan0 IEEE 802.11bg ESSID:"hidden"
> Bit Rate=54 Mb/s Tx-Power=20 dBm
> wlan1 IEEE 802.11bgn ESSID:"hidden"
> Bit Rate=58.5 Mb/s Tx-Power=20 dBm
> wlan2 IEEE 802.11bgn ESSID:"hidden"
> Bit Rate=39 Mb/s Tx-Power=20 dBm
>
> box2:
> -------------
> wlan0 IEEE 802.11bgn ESSID:"hidden"
> Bit Rate=58.5 Mb/s Tx-Power=20 dBm
> wlan1 IEEE 802.11bgn ESSID:"hidden"
> Bit Rate=52 Mb/s Tx-Power=20 dBm
> wlan2 IEEE 802.11bgn ESSID:"hidden"
> Bit Rate=52 Mb/s Tx-Power=20 dBm
>
> But I was curious if anyone had achieved > 10 MiB/s with any wireless adapter
> with Linux?
>
> Also, those native Linux USB adapters (carl) work good, so far.
> With the patch provided earlier for the rt2800usb driver, it is no longer
> crashing under 3.0 so I put two of them on a single box plus a carl based one,
> now I get better I/O, e.g. 4MiB/s x 6 = 24MiB/s.

On a 150 Mbps connection running the following script

#!/bin/sh

dest="sonylap" # set the servername

while true ; do
netperf -t TCP_MAERTS -H $dest
netperf -t TCP_STREAM -H $dest
netperf -t TCP_SENDFILE -H $dest
done

I get the following for a D-Link DWA-130 containing a Realtek RTL8192SU with 
driver r8712u:

finger@larrylap:~/bcm_git/vendor-driver/5.10.56.46> ~/netperf.sh
TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to sonylap (192.168.1.50) 
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

  87380  16384  16384    10.04      53.52
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to sonylap (192.168.1.50) 
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

  87380  16384  16384    10.03      55.58
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to sonylap 
(192.168.1.50) port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

  87380  16384  16384    10.06      65.26

I claim that 50-65 Mbps is pretty good.

We get better than 10 Mbps with lots of different adapters.

Larry
