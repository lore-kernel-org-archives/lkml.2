Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790Ab2EONse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:48:34 -0400
Received: from antcom.de ([188.40.178.216]:39171 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758940Ab2EONsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:48:32 -0400
Message-ID: <4FB25EAC.10205@antcom.de>
Date: Tue, 15 May 2012 15:48:28 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Huang Shijie <b32955@freescale.com>, Bastian Hecht <hechtb@googlemail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Lei Wen <leiwen@marvell.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MTD: LPC32xx SLC NAND driver
References: <1336829386-23301-1-git-send-email-stigge@antcom.de>  <1337068543.2528.143.camel@sauron.fi.intel.com>  <4FB2109A.2080505@freescale.com> <4FB25837.2050603@antcom.de> <1337088703.2528.208.camel@sauron.fi.intel.com>
In-Reply-To: <1337088703.2528.208.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2012 03:31 PM, Artem Bityutskiy wrote:
>> As I understand loops_per_jiffy, this loop will take much longer
>> than the 100 ms you defined above?
> 
> Not sure about much, but longer. The idea is that this is about
> the error path so if we report -EIO with a slight delay - no
> problem.

Turned out that the condition (FIFO empty) is always true for me.
Keeping the check for safety reasons for now, doing the timeout with
msleep()s which should be (cpu-wise) "social" enough and are
unexpected anyway but do approximate the ms timeout more precisely.

Roland
