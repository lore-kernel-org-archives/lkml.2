Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2EWMl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 08:41:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37382 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2EWMly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 08:41:54 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.15.47]
In-Reply-To: <4FBB8BCB.3010802@stericsson.com>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
 <1330589497-4139-2-git-send-email-ohad@wizery.com> <4F6354E4.8030704@monstr.eu>
 <CAK=Wgbbbi4GnuHedSh6cR1LhkZr8c9q6i=_TLSL252LpPB8Xsw@mail.gmail.com>
 <CAK=WgbYeQr5ZwTSBo+ZJUzN7fQ--0QbC8HSjrGT-Geycs4SKcg@mail.gmail.com>
 <CAHTX3d+=QTZo994jct6+pPqsCniG0B2a_9q6fLdGjvcbZ7qj_A@mail.gmail.com>
 <CAK=WgbahzGHmvszw6HBgihN4NcPA8ceaQCNSOk_FC61bToxBXQ@mail.gmail.com>
 <CAHTX3dK8rDomYqWvBX1ay200AmM1dBCYD3nJ2UYbzC_SSFankw@mail.gmail.com>
 <4FBB5908.4010505@stericsson.com> <CAK=WgbYKMh8oifeC-A9LYq8GV_Nb7L8wc198YZujGEsp9mmvsw@mail.gmail.com>
 <4FBB8BCB.3010802@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 23 May 2012 15:41:33 +0300
Message-ID: <CAK=WgbYdLqMBPeFsAHw+_zyLpVYeARc2oB_gNt9H66SMmZgt=g@mail.gmail.com>
Subject: Re: [PATCH 1/7] remoteproc: resource table overhaul
To: frq09524 <ludovic.barre@stericsson.com>
Cc: Michal Simek <monstr@monstr.eu>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ludovic,

On Tue, May 22, 2012 at 3:51 PM, frq09524 <ludovic.barre@stericsson.com> wrote:
> In my previous patch, to find the correct subdevice that match with physical memory, I used pa member of rproc_mem_entry.

I'm not sure we want to find these subdevices using the physical
memory of the expected region.

Doing so means more work when setting up those numbers initially, and
may also break if/when those number changes.

What do you think about looking up those subdevices by names?

E.g. before allocating the vrings, we may look for a subdevice called
"vrings-mem". If one exists, we'll use it when invoking the DMA API.
If not, we'll just use the default rproc device.

This way we don't need to change the firmware if/when we change the
memory regions allocated for each purpose.

Thanks,
Ohad.
