Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2KFXH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:07:56 -0500
Received: from mout.web.de ([212.227.17.12]:58788 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2KFXHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:07:55 -0500
Message-ID: <50999815.4020701@web.de>
Date: Wed, 07 Nov 2012 00:07:01 +0100
From: =?ISO-8859-1?Q?S=F6ren_Moch?= <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Lior Amsalem <alior@marvell.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        m.szyprowski@samsung.com
Subject: Re: [PATCH V2 1/4] arm: mvebu: increase atomic coherent pool size
 for armada 370/XP
References: <5099810D.9040902@web.de> <20121106223257.GB30428@lunn.ch>
In-Reply-To: <20121106223257.GB30428@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:e+F5y/Ss/PqFitvjctE7lpfywxJEIcxTHa4MiWAv2QK
 pfHaEPeDGv/NvWVAvio3atO5QTVCDY9sKU/x2a3uJeZA+dtO4r
 84zFyesoRJT1BGCO5zSFf4f28QoPMpwSYtR/+dDt3dtrwtu3AV
 gt8g2qz7Jr1MJ+Zcq969iQdj+7OEQPvBk2bYqj7KFCnhAiEy+G
 eJKqizSouh3KP38ONtn0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 >>> For Armada 370/XP we have the same problem that for the commit
 >>> cb01b63, so we applied the same solution: "The default 256 KiB
 >>> coherent pool may be too small for some of the Kirkwood devices, so
 >>> increase it to make sure that devices will be able to allocate their
 >>> buffers with GFP_ATOMIC flag"
 >>
 >> I see a regression from linux-3.5 to linux-3.6 and think there might
 >> be a fundamental problem
 >> with this patch. On my Kirkwood system (guruplug server plus) with
 >> linux-3.6.2 I see following
 >> errors and corresponding malfunction even with further increased
 >> (2M, 4M) pool size:
 >>
 >> Oct 19 00:41:22 guru kernel: ERROR: 4096 KiB atomic DMA coherent
 >> pool is too small!
 >> Oct 19 00:41:22 guru kernel: Please increase it with coherent_pool=
 >> kernel parameter!
 >>
 >> So I had to downgrade to linux-3.5 which is running without problems.
 >>
 >> I use SATA and several DVB sticks (em28xx / drxk and dib0700).
 >
 > I'm guess its the DVB sticks which are causing the problems. We have a
 > number of kirkwood devices with two SATA devices which had problems
 > until we extended the coherent_pool. The DVB sticks are probably take
 > more coherent RAM. There was also an issue found recently:
 >
 > http://www.spinics.net/lists/arm-kernel/msg203962.html
 >
 > That conversation has gone quiet, but that could be because the
 > participants are at ELCE.
 >
 >          Andrew

OK, I hope this GFP flag correction will help.

Could there be a fragmentation problem in the coherent_pool with the
different drivers running under heavy load?
With a pool size of 1M I see this error after several minutes, with a 4M
pool I see this error after several 10 minutes. Difficult to test, but not
acceptable on a production system.

Soeren
