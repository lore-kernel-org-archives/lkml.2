Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab2KFV3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:29:34 -0500
Received: from mout.web.de ([212.227.17.12]:56158 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2KFV3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:29:33 -0500
Message-ID: <5099810D.9040902@web.de>
Date: Tue, 06 Nov 2012 22:28:45 +0100
From: =?ISO-8859-1?Q?S=F6ren_Moch?= <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        m.szyprowski@samsung.com
Subject: Re: [PATCH V2 1/4] arm: mvebu: increase atomic coherent pool size
 for armada 370/XP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:AQXqCTJPFOFz8q4dBILryYuAM4x/awKMLibA+wBPc9s
 yGceqGOIMUnXclYiQbBKoN6ZzfDJEvYhyYona5AXYFQsHsGlSs
 fhrS+d3YPqIv9txfXG2NJ1HmxGdObyP2FQPfbJdZfS8YClbUeG
 owP+fpvFphBY4sP2uidLo2fOqjYop59U1R7yROACZjMR0N2O/D
 qIqpc7icZd0NEPVzuijJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resent as plain text, sorry.


 > For Armada 370/XP we have the same problem that for the commit
 > cb01b63, so we applied the same solution: "The default 256 KiB
 > coherent pool may be too small for some of the Kirkwood devices, so
 > increase it to make sure that devices will be able to allocate their
 > buffers with GFP_ATOMIC flag"

I see a regression from linux-3.5 to linux-3.6 and think there might be 
a fundamental problem
with this patch. On my Kirkwood system (guruplug server plus) with 
linux-3.6.2 I see following
errors and corresponding malfunction even with further increased (2M, 
4M) pool size:

Oct 19 00:41:22 guru kernel: ERROR: 4096 KiB atomic DMA coherent pool is 
too small!
Oct 19 00:41:22 guru kernel: Please increase it with coherent_pool= 
kernel parameter!

So I had to downgrade to linux-3.5 which is running without problems.

I use SATA and several DVB sticks (em28xx / drxk and dib0700).

I already sent this bug report to m.szyprowski and 
gregory.clementearlier, but
Sebastian suggested to send it to the mailing list and the responsible 
maintainers, too.

Please write to my e-mail directly if you have further questions or 
patches for me to test.

Regards,
Soeren

