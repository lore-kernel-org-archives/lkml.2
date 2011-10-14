Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1JNRyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:54:50 -0400
Received: from antispam02.maxim-ic.com ([205.153.101.183]:48516 "EHLO
	antispam02.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab1JNRyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:54:47 -0400
X-Greylist: delayed 824 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Oct 2011 13:54:47 EDT
X-ASG-Debug-ID: 1318614061-02256b132520be10001-xx1T2L
X-Barracuda-Envelope-From: Peter.Hsiang@maxim-ic.com
From: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
To: Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 14 Oct 2011 10:40:58 -0700
Subject: RE: [PATCH] ASoC: max98095: Convert codec->hw_write to snd_soc_write
Thread-Topic: [PATCH] ASoC: max98095: Convert codec->hw_write to
 snd_soc_write
X-ASG-Orig-Subj: RE: [PATCH] ASoC: max98095: Convert codec->hw_write to snd_soc_write
Thread-Index: AcyKI2/P3/ExAcMKQ4Cm3qLzY+4O0gAcUxng
Message-ID: <B2150E1E4418E1438554A300EA5040E40DDFD2E54E@ITSVLEX06.it.maxim-ic.internal>
References: <1318563798.9296.1.camel@phoenix>
In-Reply-To: <1318563798.9296.1.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Barracuda-Connect: maxdalex02.maxim-ic.internal[10.16.15.104]
X-Barracuda-Start-Time: 1318614061
X-Barracuda-URL: http://192.168.10.183:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.02
X-Barracuda-Spam-Status: No, SCORE=0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=THREAD_INDEX, THREAD_TOPIC
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.77326
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.01 THREAD_INDEX           thread-index: AcO7Y8iR61tzADqsRmmc5wNiFHEOig==
	0.01 THREAD_TOPIC           Thread-Topic: ...(Japanese Subject)...
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9EHt9lB020566

On Fri, Oct 14, 2011, Axel Lin wrote:
> codec->hw_write is broken now, convert codec->hw_write to
> snd_soc_write.
> 

The hardware has 2 banks of registers sharing a section in I2C register space.
The 1st bank is the primary one and is cached.  
The 2nd bank is for loading coefficients only and they do not need cache.
These coefficients registers are therefore direct writes.
Changing this to a cached write will overwrite the cache.

Peter
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
