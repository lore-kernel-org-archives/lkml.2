Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab1FWL4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:56:39 -0400
Received: from blu0-omc4-s25.blu0.hotmail.com ([65.55.111.164]:22449 "EHLO
	blu0-omc4-s25.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759236Ab1FWL4h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:56:37 -0400
Message-ID: <BLU158-w370CB20409B2C48E8D14C887530@phx.gbl>
X-Originating-IP: [129.215.91.109]
From: Fred Matthews <fredmm@hotmail.co.uk>
To: <shafi.wireless@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath9k-devel@venema.h4ckr.net>,
        <ath9k-devel@venema.h4ckr.net>, <susinder@qca.qualcomm.com>,
        <adrian@freebsd.org>
Subject: RE: [ath9k-devel] Disabling the third antenna for AR9380 in ath9k
Date: Thu, 23 Jun 2011 12:56:36 +0100
Importance: Normal
In-Reply-To: <BANLkTinubW6Pq7NHrpeG2pLf8SC3xLFdGg@mail.gmail.com>
References: <BLU158-w185CA0272A5A3CC187AF1E876E0@phx.gbl>,<BANLkTi=B3uZ1qmL6oPyXXQ1n-BCAftND-A@mail.gmail.com>,<BLU158-w57EC92C4495F7C9645D7F187500@phx.gbl>,<BANLkTinubW6Pq7NHrpeG2pLf8SC3xLFdGg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Jun 2011 11:56:36.0897 (UTC) FILETIME=[9AD15110:01CC319C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,

Regarding streams used in Minstrel RC, I found that in "net/mac80211/rc80211_minstrel_ht.h", at line 16, there is "#define MINSTREL_MAX_STREAMS  3", that sets the number of streams for minstrel RC.

Now can someone help to pass this onto debugfs, so that we can change from 3 streams to 2 streams at runtime like the rx_chainmask. I tried creating a u8 stream_number and struct dentry *dbg_stream_number in the header file, then a debugfs_create_u8 in the c file. Then used it to redefine MINSTREL_MAX_STREAMS, but when I tested this I got errors, therefore, can anyone kindly share a patch to do this correctly.

Thanks in advance



On Wed, Jun 22, 2011 at 3:57 PM, Mohammed Shafi wrote:
> On Wed, Jun 22, 2011 at 6:12 PM, Fred Matthews wrote:
>>
>> Hi,
>>
>> I used that command to disable the third antenna, and applied it to both AP
>> and STA AR9380 NICs.
>> I then performed an IPerf test between both and then captured the statistics
>> from the sender, (below) .
>> You can see that in rc_stats (minstrel), the rate control actually
>> "attempts" sending on 3 stream MCSs (16-23) around 256 times each.
>
> just a guess. as we are changing the chain mask via debugfs and there
> may be a chance we may not have informed the minstrel rate control
> which is maintained in upper layer(mac80211) and it might be taking
> what we have configured the chain masks while we had initialized the
> device and i have very little idea about ministrel rate control
>
>>
>> Is there any way to prevent the RC from even attempting those rates, as if I
>> where to fully imitate an AR9280, it shouldnt attempt at those MCSs.
>
> may be we can try with ath9k rate control, and see what happens which
> is within the ath9k driver and affects xmit.c and it may have been
> informed of the chain mask change.
>
>>
>> Can Susinders comments also be detailed.
>>
>> Thanks in advance
>>
>> # cat /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0/stations/00\MAC/
>>
>> AUTH
>> ASSOC
>> AUTHORIZED
>> WME
>> ht supported
>> cap: 0x11ce
>>     HT20/HT40
>>     SM Power Save disabled
>>     RX HT40 SGI
>>     TX STBC
>>     RX STBC 1-stream
>>     Max AMSDU length: 7935 bytes
>>     DSSS/CCK HT40
>> ampdu factor/density: 3/6
>> MCS mask: ff ff ff 00 00 00 00 00 00 00
>> MCS tx params: 1
>> 792
>> 150 ffff ffff ffff ffff ffff 60 ffff ffff ffff ffff ffff ffff ffff ffff ffff
>> a40
>> -77
>> 0
>> type      rate     throughput  ewma prob   this prob  this succ/attempt
>> success    attempts
>> HT20/LGI    MCS0        6.6       99.9      100.0          0(  0)        163
>>         230
>> HT20/LGI    MCS1       13.1      100.0      100.0          0(  0)         75
>>          75
>> HT20/LGI    MCS2       19.3      100.0      100.0          0(  0)        252
>>         252
>> HT20/LGI    MCS3       25.4      100.0      100.0          0(  0)         75
>>          75
>> HT20/LGI    MCS4       36.2       97.5      100.0          0(  0)        413
>>         474
>> HT20/LGI    MCS5        0.0        0.0        0.0          0(  0)          0
>>          76
>> HT20/LGI    MCS6        0.0        0.0        0.0          0(  0)          0
>>          80
>> HT20/LGI    MCS7        0.0        0.0        0.0          0(  0)          0
>>         256
>> HT20/LGI    MCS8       13.1      100.0      100.0          0(  0)         75
>>          75
>> HT20/LGI    MCS9       25.4      100.0      100.0          0(  0)         70
>>          70
>> HT20/LGI    MCS10      34.2       92.2      100.0          0(  0)         79
>>          82
>> HT20/LGI    MCS11       0.0        0.0        0.0          0(  0)          0
>>          76
>> HT20/LGI    MCS12       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT20/LGI    MCS13       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT20/LGI    MCS14       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT20/LGI    MCS15       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT20/LGI    MCS16       0.0        0.0        0.0          0(  0)          0
>>          75
>> HT20/LGI    MCS17       0.0        0.0        0.0          0(  0)          0
>>          68
>> HT20/LGI    MCS18       0.0        0.0        0.0          0(  0)          0
>>          85
>> HT20/LGI    MCS19       0.0        0.0        0.0          0(  0)          0
>>         257
>> HT20/LGI    MCS20       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT20/LGI    MCS21       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT20/LGI    MCS22       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT20/LGI    MCS23       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS0       13.6      100.0      100.0          0(  0)         75
>>          75
>> HT40/LGI    MCS1       26.5      100.0      100.0          0(  0)         72
>>          72
>> HT40/LGI    MCS2       38.3      100.0      100.0          0(  0)         73
>>          73
>> HT40/LGI    MCS3       49.7       99.9      100.0          0(  0)         70
>>          73
>> HT40/LGI    MCS4        0.0        0.0        0.0          0(  0)         10
>>        1220
>> HT40/LGI    MCS5        0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS6        0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS7        0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS8       26.2       98.9      100.0          0(  0)         73
>>          74
>> HT40/LGI    MCS9       49.3       99.2      100.0          0(  0)         67
>>          69
>> HT40/LGI    MCS10      20.5       28.9        0.0          0(  0)         14
>>         255
>> HT40/LGI    MCS11       0.0        0.0        0.0          0(  0)          0
>>         257
>> HT40/LGI    MCS12       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS13       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS14       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS15       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS16       0.0        0.0        0.0          0(  0)          0
>>          74
>> HT40/LGI    MCS17       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS18       0.0        0.0        0.0          0(  0)          0
>>         255
>> HT40/LGI    MCS19       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS20       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS21       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS22       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/LGI    MCS23       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS0       15.1      100.0      100.0          0(  0)         70
>>          70
>> HT40/SGI    MCS1       29.2      100.0      100.0          0(  0)         72
>>          72
>> HT40/SGI  t MCS2       38.5       91.3      100.0          0(  0)         81
>>          83
>> HT40/SGI   PMCS3       54.3       99.5      100.0          0(  0)      66536
>>       67803
>> HT40/SGI    MCS4        0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS5        0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS6        0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS7        0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS8       29.2      100.0      100.0          0(  0)         67
>>          67
>> HT40/SGI T  MCS9       54.6       99.9      100.0          0(  0)     310227
>>      312339
>> HT40/SGI    MCS10      22.7       29.3      100.0          0(  0)         14
>>     46.8 Mbits/sec    255
>> HT40/SGI    MCS11       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS12       0.0        0.0        0.0          0(  0)          0
>>         255
>> HT40/SGI    MCS13       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS14       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS15       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS16       0.0        0.0        0.0          0(  0)          0
>>          68
>> HT40/SGI    MCS17       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS18       0.0        0.0        0.0          0(  0)          0
>>         255
>> HT40/SGI    MCS19       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS20       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS21       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS22       0.0        0.0        0.0          0(  0)          0
>>         256
>> HT40/SGI    MCS23       0.0        0.0        0.0          0(  0)          0
>>         256
>>
>> Total packet count::    ideal 365056      lookaround 13702
>> Average A-MPDU length: 5.4
>>
>>> Date: Tue, 21 Jun 2011 14:25:36 +0530
>>> Subject: Re: [ath9k-devel] Disabling the third antenna for AR9380 in ath9k
>>> From: shafi.wireless@gmail.com
>>> To: fredmm@hotmail.co.uk
>>> CC: linux-kernel@vger.kernel.org; linux-wireless@vger.kernel.org;
>>> ath9k-devel@venema.h4ckr.net; ath9k-devel@lists.ath9k.org;
>>> susinder@qca.qualcomm.com
>>>
>>> On Tue, Jun 21, 2011 at 2:07 AM, Fred Matthews
>>> wrote:
>>> > Hi all,
>>> > I am installing the AR9380 NIC on laptops, but some only have two UFL
>>> > connectors, and thus I was wondering if using only two of the UFL
>>> > antenna
>>> > ports will have any negative effect or difference than installing a 2x2
>>> > NIC
>>> > (AR9280 for example which has only 2 ports anyway). Please kindly
>>> > explain
>>> > with references if possible.
>>> > Also for example is there anyway to disable transmission on the third
>>> > UFL
>>> > port (antenna) from ath9k or otherwise.
>>> > Thank you all very much
>>>
>>> you can change the tx/rx chainmask for 3x3 AR9380 to disable
>>> transmission on the third antenna
>>> cd /sys/kernel/debug/ieee80211/phy0/ath9k# echo 0x3 > tx_chainmask
>>> cd /sys/kernel/debug/ieee80211/phy0/ath9k# echo 0x3 > rx_chainmask
>>>
>>> after this, ideally it should operate as 2x2 device as per Susinders
>>> comments. but if you got AR9280 please try to use that if 2 antenna is
>>> the constraint.
>>>
>>>
>>> > _______________________________________________
>>> > ath9k-devel mailing list
>>> > ath9k-devel@lists.ath9k.org
>>> > https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>>> >
>>> >
>>>
>>>
>>>
>>> --
 		 	   		  