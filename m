Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab1CHSDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:03:51 -0500
Received: from 75-145-127-229-Colorado.hfc.comcastbusiness.net ([75.145.127.229]:39644
	"EHLO gw.co.teklibre.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751292Ab1CHSDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:03:48 -0500
From: d@taht.net (Dave =?utf-8?Q?T=C3=A4ht?=)
To: linux-wireless <linux-wireless@vger.kernel.org>,
        bloat-devel <bloat-devel@lists.bufferbloat.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Some debloat-testing results with problems of 2.6.38-rc7-bloat2-db
Organization: Teklibre - http://www.teklibre.com
Date: Tue, 08 Mar 2011 11:03:45 -0700
Message-ID: <87sjuxmqv2.fsf@cruithne.co.teklibre.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Over the weekend I did some tests of the debloat-testing[1] tree,
there's good, bad, and ugly results thus far.

* The Good

There are now ubuntu 10.10 debs up fpr 2.6.38-rc7-bloat2-db up for
x86_64 systems at:

http://mirrors.bufferbloat.net/debs/

The kernel boots. I've had it running for 3 days. In using my iwlagn

03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or
AGN [Kedron] Network Connection (rev 61)

Which I think supports aggregation... (?)

I can happily report that the 130ms+ latency under load I experienced
with this device on the default kernel has now been reduced to under ~3ms
(using ping to test and iperf to saturate) while connected at 38Mbit.

* The Bad

The git tree[2] was updated this morning to -rc8. It would be nice to
have debs for x86 and other architectures, too.

While performing the wireless testing above, I also experienced 11%
packet loss (this was admittedly under purposely bad conditions - 2
floors, 3 concrete walls, not so good antennas - see here[3] for my test
rig - I was using a partially debloated wndr3700 for this test too)

I haven't had time to check if the patched TC[4] supports the
additional parameters of CHOKe and SFB yet. And that said, shaper
scripts that integrate these AQMs are direly needed. Anyone?

* The Ugly

I'm concerned that the effective latency reduction I'm experiencing for
TCP/IP is more tied to the wireless packet loss, rather than the new
eBDP algorithm actually addressing it. How to go about testing this?
Seeing some knobs or stats?

The patches to the wired e1000e (and most likely e1000 driver) do not
work correctly with TX rings set below 64. At 16, it ends up in a near
permanent reset state:

e1000e 0000:00:19.0: eth0: Reset adapter
e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO

It's harder to trigger at TX ring 32, but still happens under load.

Even disabling TSO/GSO etc via ethtool had no effect. Thankfully you can
increase the TX ring back to 64 and have a working network card again.

It would be good if someone with more of a clue than the idjit that
produced those patches could look into what it would really take to be
able to reduce the dynamic range of the e1000e wired network DMA TX ring
down to very low (say, 4) levels and still have TSO/GSO work. Having a
good look at a responsive network stack without the complexities of
wireless involved would be very helpful.

Aside from that, no babies eaten, and progress made. My thx to John
Linville, Dave Woodhouse, and everyone else involved in pulling this
tree together!


[1] https://lists.bufferbloat.net/pipermail/bloat-devel/2011-February/000061.html 
[2] http://git.infradead.org/debloat-testing.git
[3] http://nex-6.taht.net/images/housenet.png
[4] https://github.com/dtaht/iproute2bufferbloat

-- 
Dave Taht
http://the-edge.blogspot.com

