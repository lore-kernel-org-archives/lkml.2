Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1KVUCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:02:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52137 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1KVUCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:02:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-dev@lists.linaro.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, linus.walleij@stericsson.com,
        sboyd@quicinc.com, broonie@opensource.wolfsonmicro.com,
        magnus.damm@gmail.com, linux-kernel@vger.kernel.org,
        eric.miao@linaro.org, aul@pwsan.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        skannan@quicinc.com, linux@arm.linux.org.uk, arnd.bergmann@linaro.org,
        linux-omap@vger.kernel.org, jeremy.kerr@canonical.com
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
Date: Tue, 22 Nov 2011 21:02:08 +0100
Message-ID: <9315670.oOZAWsuHPb@wuerfel>
User-Agent: KMail/4.7.2 (Linux/3.1.0-rc8nosema+; KDE/4.7.2; x86_64; ; )
In-Reply-To: <CACxGe6vK-vHvSbd9N2k3FZY4gGVS_DETx0BbfPgNghTkOncjpg@mail.gmail.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <CAPtuhTheG-mvoGMaB2y9BSKF-abm2yigoN-SXaeCb+P5R6t_Dg@mail.gmail.com> <CACxGe6vK-vHvSbd9N2k3FZY4gGVS_DETx0BbfPgNghTkOncjpg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wtuzTUcKwmpD+O0Ffh/Zz4/MAbumBvaRZ1eubgues/l
 KVT5ojsQdPcahNK4XnEvSdOxE4f40Sxl8KNT2sYiPiYHaWh3Nc
 42ceZ0IbSuvI634sAiw3FI2IsfxNasGLAv9SRcJ7jCOAC8QU/j
 L2jTftK65IQJAYodVQSfUrZIOvZ0EHimwg++iXsHOyUrrpg8Lr
 E0zWkbNAPB3f6suFhn9e5hfSEQcP8+gMHykzbataFgAG8u+WBL
 I2iK6wTPhBGCfBAql4n3xzZhCACYED+9GY3OiPZaz7GA15Zsiu
 y/8XKKWdIk2AG1ANg4QzvOm2WZNTPCp/ddBa3oYxTA/p1t6Z5T
 rqhkzm+7wILz3t1sPm7o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 November 2011 12:19:51 Grant Likely wrote:
> On Tue, Nov 22, 2011 at 11:01 AM, Mike Turquette <mturquette@linaro.org> wrote:
>
> > Others have requested to have knobs made available for actually
> > performing clk_enable/clk_disable and even clk_set_rate from
> > userspace.  I hate this idea and won't implement it.  I encourage
> > anyone that needs this to do it in debugfs.
> >
> > Does that work-split make sense to you, or do you still not like the
> > idea of having topology and read-only info in sysfs?
> 
> Unless there is a solid real-world use case for exporting this data to
> userspace, I do not think sysfs is a good idea.  As long as the usage
> (beyond debug) is theoretical I think the whole thing should be in
> debugfs.  It can always be moved at a later date If a real use case
> does become important.

I would recomment not to spend any time on implementing a debugfs interface
for this right now. As far as I can tell, nothing relies on exporting
the structure to user space, so Mike's time is better spent on getting the
other four patches merged.

Note that the static topology information about clocks will already be
visible in /proc/devicetree when that is enabled and the clocks are
described in the .dts file.

	Arnd
