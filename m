Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1HDRLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 13:11:43 -0400
Received: from mout4.freenet.de ([195.4.92.94]:34359 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab1HDRLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 13:11:36 -0400
Message-ID: <4E3AD2B9.6010905@01019freenet.de>
Date: Thu, 04 Aug 2011 19:11:21 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110720 Firefox/5.0 SeaMonkey/2.2
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: Linux Wireless USB-Stick Question
References: <alpine.DEB.2.02.1108031550100.4278@p34.internal.lan> <4E39B82C.2010108@lwfinger.net>
In-Reply-To: <4E39B82C.2010108@lwfinger.net>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger schrieb:
> On 08/03/2011 02:53 PM, Justin Piszcz wrote:
>> Hi,
>>
>> Under Windows, you can achieve 10-15MiB/s..
>>
>> Under Linux, even with 150mbps USB wireless adapters, the max never
>> appears to
>> go above > 3-4MiB/s, to work around this, order more USB-wifi ticks
>> and run them
>> in parallel far away from each other with USB
>> extenders:
>>
>> box1:
>> -------------
>> wlan0 IEEE 802.11bg ESSID:"hidden"
>> Bit Rate=54 Mb/s Tx-Power=20 dBm
>> wlan1 IEEE 802.11bgn ESSID:"hidden"
>> Bit Rate=58.5 Mb/s Tx-Power=20 dBm
>> wlan2 IEEE 802.11bgn ESSID:"hidden"
>> Bit Rate=39 Mb/s Tx-Power=20 dBm
>>
>> box2:
>> -------------
>> wlan0 IEEE 802.11bgn ESSID:"hidden"
>> Bit Rate=58.5 Mb/s Tx-Power=20 dBm
>> wlan1 IEEE 802.11bgn ESSID:"hidden"
>> Bit Rate=52 Mb/s Tx-Power=20 dBm
>> wlan2 IEEE 802.11bgn ESSID:"hidden"
>> Bit Rate=52 Mb/s Tx-Power=20 dBm
>>
>> But I was curious if anyone had achieved > 10 MiB/s with any wireless
>> adapter
>> with Linux?
>>
>> Also, those native Linux USB adapters (carl) work good, so far.
>> With the patch provided earlier for the rt2800usb driver, it is no longer
>> crashing under 3.0 so I put two of them on a single box plus a carl
>> based one,
>> now I get better I/O, e.g. 4MiB/s x 6 = 24MiB/s.
> 
> On a 150 Mbps connection running the following script
> 
> #!/bin/sh
> 
> dest="sonylap" # set the servername
> 
> while true ; do
> netperf -t TCP_MAERTS -H $dest
> netperf -t TCP_STREAM -H $dest
> netperf -t TCP_SENDFILE -H $dest
> done
> 
> I get the following for a D-Link DWA-130 containing a Realtek RTL8192SU
> with driver r8712u:
> 
> finger@larrylap:~/bcm_git/vendor-driver/5.10.56.46> ~/netperf.sh
> TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to sonylap
> (192.168.1.50) port 0 AF_INET
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    10.04      53.52
> TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to sonylap
> (192.168.1.50) port 0 AF_INET
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    10.03      55.58
> TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to sonylap
> (192.168.1.50) port 0 AF_INET
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    10.06      65.26
> 
> I claim that 50-65 Mbps is pretty good.


This means about half of fast ethernet (5-6,5 MB/s). It's too
insufficient for 802.11n / 40 MHz.


rt3572sta (Linksys WUSB600N v2) against rt2860 based AP (rt2800pci) -
from one room to another:

Do 4. Aug 18:48:27 CEST 2011
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to srv (1.1.1.1)
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.07      82.51
TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to srv (1.1.1.1)
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.02     128.94
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to srv (1.1.1.1)
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.09      77.47

rt2800usb doesn't work at all with WUSB600N v2.



ar9285 (ath9k) against rt2860 based AP (rt2800pci) - through reinforced
concrete floor:

Do 4. Aug 19:03:04 CEST 2011
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to srv (1.1.1.1)
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.10      80.23
TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to srv (1.1.1.1)
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.06      80.82
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to srv (1.1.1.1)
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.10      78.51


-> there is room for optimization! I don't think, that the rt3572sta is
the best solution absolutely seen :-). Unfortunately, I don't have a
windows machine to compare ... . Maybe, I could get one to test ... .



Andreas
