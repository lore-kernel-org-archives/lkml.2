Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab1FVNqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 09:46:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46756 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1FVNqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:46:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=G0DEWiQkWgQWsJ/Gx+VvFYDLhYfyI6gc1vpRbXZWXKWtEhSOgEB/wzFN5OXLmpvZyZ
         OXVcZ7u65nw54wzaQcef5qsjbfTyuzlDRYv7ddNYO9yVdB1aIcMI0Z0fczVZQgYdjqwO
         ZDthJ8e7/3XSOoKOQ78kRBnzMQuYR4M/CbJsA=
MIME-Version: 1.0
In-Reply-To: <BLU158-w57EC92C4495F7C9645D7F187500@phx.gbl>
References: <BLU158-w185CA0272A5A3CC187AF1E876E0@phx.gbl>
	<BANLkTi=B3uZ1qmL6oPyXXQ1n-BCAftND-A@mail.gmail.com>
	<BLU158-w57EC92C4495F7C9645D7F187500@phx.gbl>
Date: Wed, 22 Jun 2011 21:40:01 +0800
X-Google-Sender-Auth: 6l0F92AKSEKaunYY5KYiO8JqCeo
Message-ID: <BANLkTi=22ifybfJ6tfNnw_giv2snRTGeKw@mail.gmail.com>
Subject: Re: [ath9k-devel] Disabling the third antenna for AR9380 in ath9k
From: Adrian Chadd <adrian@freebsd.org>
To: Fred Matthews <fredmm@hotmail.co.uk>
Cc: shafi.wireless@gmail.com, susinder@qca.qualcomm.com,
        ath9k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5MDkLur022507

Just find where in ath9k it sets the supported streams and set it to 2, not 3.


Adrian

On 22 June 2011 20:42, Fred Matthews <fredmm@hotmail.co.uk> wrote:
>
> Hi,
>
> I used that command to disable the third antenna, and applied it to both AP
> and STA AR9380 NICs.
> I then performed an IPerf test between both and then captured the statistics
> from the sender, (below) .
> You can see that in rc_stats (minstrel), the rate control actually
> "attempts" sending on 3 stream MCSs (16-23) around 256 times each.
>
> Is there any way to prevent the RC from even attempting those rates, as if I
> where to fully imitate an AR9280, it shouldnt attempt at those MCSs.
>
> Can Susinders comments also be detailed.
>
> Thanks in advance
>
> # cat /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0/stations/00\MAC/
>
> AUTH
> ASSOC
> AUTHORIZED
> WME
> ht supported
> cap: 0x11ce
>     HT20/HT40
>     SM Power Save disabled
>     RX HT40 SGI
>     TX STBC
>     RX STBC 1-stream
>     Max AMSDU length: 7935 bytes
>     DSSS/CCK HT40
> ampdu factor/density: 3/6
> MCS mask: ff ff ff 00 00 00 00 00 00 00
> MCS tx params: 1
> 792
> 150 ffff ffff ffff ffff ffff 60 ffff ffff ffff ffff ffff ffff ffff ffff ffff
> a40
> -77
> 0
> type      rate     throughput  ewma prob   this prob  this succ/attempt
> success    attempts
> HT20/LGI    MCS0        6.6       99.9      100.0          0(  0)        163
>         230
> HT20/LGI    MCS1       13.1      100.0      100.0          0(  0)         75
>          75
> HT20/LGI    MCS2       19.3      100.0      100.0          0(  0)        252
>         252
> HT20/LGI    MCS3       25.4      100.0      100.0          0(  0)         75
>          75
> HT20/LGI    MCS4       36.2       97.5      100.0          0(  0)        413
>         474
> HT20/LGI    MCS5        0.0        0.0        0.0          0(  0)          0
>          76
> HT20/LGI    MCS6        0.0        0.0        0.0          0(  0)          0
>          80
> HT20/LGI    MCS7        0.0        0.0        0.0          0(  0)          0
>         256
> HT20/LGI    MCS8       13.1      100.0      100.0          0(  0)         75
>          75
> HT20/LGI    MCS9       25.4      100.0      100.0          0(  0)         70
>          70
> HT20/LGI    MCS10      34.2       92.2      100.0          0(  0)         79
>          82
> HT20/LGI    MCS11       0.0        0.0        0.0          0(  0)          0
>          76
> HT20/LGI    MCS12       0.0        0.0        0.0          0(  0)          0
>         256
> HT20/LGI    MCS13       0.0        0.0        0.0          0(  0)          0
>         256
> HT20/LGI    MCS14       0.0        0.0        0.0          0(  0)          0
>         256
> HT20/LGI    MCS15       0.0        0.0        0.0          0(  0)          0
>         256
> HT20/LGI    MCS16       0.0        0.0        0.0          0(  0)          0
>          75
> HT20/LGI    MCS17       0.0        0.0        0.0          0(  0)          0
>          68
> HT20/LGI    MCS18       0.0        0.0        0.0          0(  0)          0
>          85
> HT20/LGI    MCS19       0.0        0.0        0.0          0(  0)          0
>         257
> HT20/LGI    MCS20       0.0        0.0        0.0          0(  0)          0
>         256
> HT20/LGI    MCS21       0.0        0.0        0.0          0(  0)          0
>         256
> HT20/LGI    MCS22       0.0        0.0        0.0          0(  0)          0
>         256
> HT20/LGI    MCS23       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS0       13.6      100.0      100.0          0(  0)         75
>          75
> HT40/LGI    MCS1       26.5      100.0      100.0          0(  0)         72
>          72
> HT40/LGI    MCS2       38.3      100.0      100.0          0(  0)         73
>          73
> HT40/LGI    MCS3       49.7       99.9      100.0          0(  0)         70
>          73
> HT40/LGI    MCS4        0.0        0.0        0.0          0(  0)         10
>        1220
> HT40/LGI    MCS5        0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS6        0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS7        0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS8       26.2       98.9      100.0          0(  0)         73
>          74
> HT40/LGI    MCS9       49.3       99.2      100.0          0(  0)         67
>          69
> HT40/LGI    MCS10      20.5       28.9        0.0          0(  0)         14
>         255
> HT40/LGI    MCS11       0.0        0.0        0.0          0(  0)          0
>         257
> HT40/LGI    MCS12       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS13       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS14       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS15       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS16       0.0        0.0        0.0          0(  0)          0
>          74
> HT40/LGI    MCS17       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS18       0.0        0.0        0.0          0(  0)          0
>         255
> HT40/LGI    MCS19       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS20       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS21       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS22       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/LGI    MCS23       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS0       15.1      100.0      100.0          0(  0)         70
>          70
> HT40/SGI    MCS1       29.2      100.0      100.0          0(  0)         72
>          72
> HT40/SGI  t MCS2       38.5       91.3      100.0          0(  0)         81
>          83
> HT40/SGI   PMCS3       54.3       99.5      100.0          0(  0)      66536
>       67803
> HT40/SGI    MCS4        0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS5        0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS6        0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS7        0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS8       29.2      100.0      100.0          0(  0)         67
>          67
> HT40/SGI T  MCS9       54.6       99.9      100.0          0(  0)     310227
>      312339
> HT40/SGI    MCS10      22.7       29.3      100.0          0(  0)         14
>     46.8 Mbits/sec    255
> HT40/SGI    MCS11       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS12       0.0        0.0        0.0          0(  0)          0
>         255
> HT40/SGI    MCS13       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS14       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS15       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS16       0.0        0.0        0.0          0(  0)          0
>          68
> HT40/SGI    MCS17       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS18       0.0        0.0        0.0          0(  0)          0
>         255
> HT40/SGI    MCS19       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS20       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS21       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS22       0.0        0.0        0.0          0(  0)          0
>         256
> HT40/SGI    MCS23       0.0        0.0        0.0          0(  0)          0
>         256
>
> Total packet count::    ideal 365056      lookaround 13702
> Average A-MPDU length: 5.4
>
>> Date: Tue, 21 Jun 2011 14:25:36 +0530
>> Subject: Re: [ath9k-devel] Disabling the third antenna for AR9380 in ath9k
>> From: shafi.wireless@gmail.com
>> To: fredmm@hotmail.co.uk
>> CC: linux-kernel@vger.kernel.org; linux-wireless@vger.kernel.org;
>> ath9k-devel@venema.h4ckr.net; ath9k-devel@lists.ath9k.org;
>> susinder@qca.qualcomm.com
>>
>> On Tue, Jun 21, 2011 at 2:07 AM, Fred Matthews <fredmm@hotmail.co.uk>
>> wrote:
>> > Hi all,
>> > I am installing the AR9380 NIC on laptops, but some only have two UFL
>> > connectors, and thus I was wondering if using only two of the UFL
>> > antenna
>> > ports will have any negative effect or difference than installing a 2x2
>> > NIC
>> > (AR9280 for example which has only 2 ports anyway). Please kindly
>> > explain
>> > with references if possible.
>> > Also for example is there anyway to disable transmission on the third
>> > UFL
>> > port (antenna) from ath9k or otherwise.
>> > Thank you all very much
>>
>> you can change the tx/rx chainmask for 3x3 AR9380 to disable
>> transmission on the third antenna
>> cd /sys/kernel/debug/ieee80211/phy0/ath9k# echo 0x3 > tx_chainmask
>> cd /sys/kernel/debug/ieee80211/phy0/ath9k# echo 0x3 > rx_chainmask
>>
>> after this, ideally it should operate as 2x2 device as per Susinders
>> comments. but if you got AR9280 please try to use that if 2 antenna is
>> the constraint.
>>
>>
>> > _______________________________________________
>> > ath9k-devel mailing list
>> > ath9k-devel@lists.ath9k.org
>> > https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>> >
>> >
>>
>>
>>
>> --
>> shafi
>
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
