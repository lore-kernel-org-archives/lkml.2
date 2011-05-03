Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab1ECF1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 01:27:16 -0400
Received: from a.relay.invitel.net ([62.77.203.3]:59848 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1ECF1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 01:27:14 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 01:27:14 EDT
Date: Tue, 03 May 2011 07:27:11 +0200
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH v6 3/6] video, sm501: add edid and commandline support
In-reply-to: <BANLkTik3L28mmL=LGZ_0nV7vSOX9Miw3ow@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@lists.ozlabs.org, Wolfram Sang <w.sang@pengutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@ozlabs.org,
        Ben Dooks <ben@simtec.co.uk>, Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, Wolfgang Denk <wd@denx.de>,
        Paul Mundt <lethal@linux-sh.org>
Reply-to: hs@denx.de
Message-id: <4DBF922F.8040703@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1291451028-22532-1-git-send-email-hs@denx.de>
 <1300782452-528-1-git-send-email-hs@denx.de>
 <1300782452-528-4-git-send-email-hs@denx.de>
 <20110502222716.GB15187@ponder.secretlab.ca>
 <BANLkTik3L28mmL=LGZ_0nV7vSOX9Miw3ow@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Grant,

Grant Likely wrote:
> On Mon, May 2, 2011 at 4:27 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Tue, Mar 22, 2011 at 09:27:29AM +0100, Heiko Schocher wrote:
>>> - add commandline options:
>>>   sm501fb.mode:
>>>     Specify resolution as "<xres>x<yres>[-<bpp>][@<refresh>]"
>>>   sm501fb.bpp:
>>>     Specify bit-per-pixel if not specified mode
>>>
>>> - Add support for encoding display mode information
>>>   in the device tree using verbatim EDID block.
>>>
>>>   If the "edid" entry in the "smi,sm501" node is present,
>>>   the driver will build mode database using EDID data
>>>   and allow setting the display modes from this database.
>>>
>>> Signed-off-by: Heiko Schocher <hs@denx.de>
>> Merged, thanks.
> 
> This patch causes the following build warning:

Hups ... when I posted the patch, it compiled clean ...

>   MODPOST vmlinux.o
> WARNING: vmlinux.o(.text+0x1d5572): Section mismatch in reference from
> the function sm501fb_init_fb() to the variable
> .devinit.data:sm501_default_mode
> The function sm501fb_init_fb() references
> the variable __devinitdata sm501_default_mode.
> This is often because sm501fb_init_fb lacks a __devinitdata
> annotation or the annotation of sm501_default_mode is wrong.
> 
> WARNING: vmlinux.o(.text+0x1d557a): Section mismatch in reference from
> the function sm501fb_init_fb() to the variable
> .devinit.data:sm501_default_mode
> The function sm501fb_init_fb() references
> the variable __devinitdata sm501_default_mode.
> This is often because sm501fb_init_fb lacks a __devinitdata
> annotation or the annotation of sm501_default_mode is wrong.
> 
> I've dropped the __devinitdata declaration in what I committed; can
> you investigate and post a fixup patch?

Of course, I look ASAP at it, thanks!
(Dummy question: where can I find your tree?)

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
