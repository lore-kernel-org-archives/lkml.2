Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab0HMIga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 04:36:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42630 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab0HMIg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 04:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=I0XtDEbtSOa0ddYn0h1n433SC8GJgrOff/7EzwOuinihP9TMeXVfeZHeHu7Z9VIbsj
         RRrCWAb7EQPNkvq/XF12Z45wv1ouEod18xGGoyfw9/JnQ3x1kgP7BMNCER3WoH9LUJdQ
         tiqXojJ7O8e85ryZfkhA20LWLHaguR2BPjNBQ=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas <andihartmann@01019freenet.de>
Subject: Re: rt61pci - bad performance
Date: Fri, 13 Aug 2010 10:35:39 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        linux-wireless@vger.kernel.org
References: <i3lug9$bfn$1@ID-44327.news.uni-berlin.de> <20100812161157.00d5377f.akpm@linux-foundation.org>
In-Reply-To: <20100812161157.00d5377f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201008131035.39922.helmut.schaa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

Am Freitag 13 August 2010 schrieb Andrew Morton:
> (cc's added)
> 
> On Sun, 08 Aug 2010 11:49:49 +0200
> Andreas <andihartmann@01019freenet.de> wrote:

[...]

> > wlan0     IEEE 802.11bg  ESSID:"--------"
> >            Mode:Managed  Frequency:2.412 GHz  Access Point: some AP
> >            Bit Rate=1 Mb/s   Tx-Power=5 dBm
> >            Retry  long limit:7   RTS thr:off   Fragment thr:off
> >            Encryption key:off
> >            Power Management:off
> >            Link Quality=38/70  Signal level=-72 dBm
> >            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >            Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> > 
> > The throughput is measured with ping -f -s 7000 and xosview -n.

This doesn't look like an appropriate way to measure the throughput. You
should use something like iperf [1] or netperf [2] for your measurements
to get more accurate results.

> > If I'm using ndiswrapper with the windows driver, first of all, I can 
> > see additional information in iwconfig:
> > 
> > wlan0     IEEE 802.11g  ESSID:"--------"
> >            Mode:Managed  Frequency:2.412 GHz  Access Point: some AP
> >            Bit Rate=54 Mb/s   Tx-Power:20 dBm   Sensitivity=-121 dBm
> >            RTS thr=2347 B   Fragment thr=2346 B
> >            Encryption key:some key   Security mode:restricted
> >            Power Management:off
> >            Link Quality:62/100  Signal level:-56 dBm  Noise level:-96 dBm
> >            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
> >            Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> > 
> > 
> > There is a switch for sensitivity (which is not supported with rt61pci) 
> > and the link quality compared with ndiswrapper is worse (38% to 62%).

I wouldn't trust the link quality values that much, the calculation in rt61pi
is most likely different from what the windows driver does. So it is not
really comparable.

> > The following is remarkably too:
> > ndiswrapper uses a Tx-Power of 20 dBm, rt61pci only 5 dBm. I don't know, 
> > why rt61pci uses 5 dBm. It's a hard limit and I can't set it on a value 
> > higher than 5 unless the driver is patched. Nevertheless, setting a 
> > higher value (of 20 dBm) by patch does not mean to get a better performance.

Could you elaborate please? Did you actually try to patch it or is this just
an assumption?

> > Ndiswrapper shows an encryption key, rt61pci not. Does it mean, that 
> > rt61pci doesn't use hardware encryption?

hw crypto should be enabled by default in rt61pci, however, I don't know
if it is actually working ;)

> > With ndiswrapper, the rt61pci-chip achieves a throughput of 2,6 MBytes/s 
> > - that's about 1 MByte/s more than rt61pci.
> > 
> > I have to say, that the difference between rt61pci and ndiswrapper gets 
> > worse if the link quality is getting more badly. Or in other words: 
> > ndiswrapper handles bad connections better then rt61pci.
> > 
> > 
> > Do you have any idea to get rt61pci working as fast as ndiswrapper?

Please run proper measurements first and post the results again.

Thanks,
Helmut

[1] http://sourceforge.net/projects/iperf/
[2] http://www.netperf.org/
