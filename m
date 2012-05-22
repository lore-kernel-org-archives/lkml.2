Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab2EVMwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:52:18 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:51872 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751168Ab2EVMwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:52:16 -0400
Message-ID: <4FBB8BCB.3010802@stericsson.com>
Date: Tue, 22 May 2012 14:51:23 +0200
From: frq09524 <ludovic.barre@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
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
Subject: Re: [PATCH 1/7] remoteproc: resource table overhaul
References: <1330589497-4139-1-git-send-email-ohad@wizery.com> <1330589497-4139-2-git-send-email-ohad@wizery.com> <4F6354E4.8030704@monstr.eu> <CAK=Wgbbbi4GnuHedSh6cR1LhkZr8c9q6i=_TLSL252LpPB8Xsw@mail.gmail.com> <CAK=WgbYeQr5ZwTSBo+ZJUzN7fQ--0QbC8HSjrGT-Geycs4SKcg@mail.gmail.com> <CAHTX3d+=QTZo994jct6+pPqsCniG0B2a_9q6fLdGjvcbZ7qj_A@mail.gmail.com> <CAK=WgbahzGHmvszw6HBgihN4NcPA8ceaQCNSOk_FC61bToxBXQ@mail.gmail.com> <CAHTX3dK8rDomYqWvBX1ay200AmM1dBCYD3nJ2UYbzC_SSFankw@mail.gmail.com> <4FBB5908.4010505@stericsson.com> <CAK=WgbYKMh8oifeC-A9LYq8GV_Nb7L8wc198YZujGEsp9mmvsw@mail.gmail.com>
In-Reply-To: <CAK=WgbYKMh8oifeC-A9LYq8GV_Nb7L8wc198YZujGEsp9mmvsw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ohad

In my previous patch, to find the correct subdevice that match with 
physical memory, I used pa member of rproc_mem_entry.
but today in these 2 resources: fw_rsc_trace, fw_rsc_vdev_vring, pa 
menber has been removed.

for fw_rsc_trace it's not a problem, because use rproc_da_to_va and 
carveout feature.

but for fw_rsc_vdev_vring, I think use da member, like this.

dev = rproc_dma_find_dev(rproc, (phys_addr_t) vring->da);
va = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
if (!va) {
	dev_err(dev, "dma_alloc_coherent failed\n");
	return -EINVAL;
}

are you OK ?

/BR
Ludovic Barré

On 05/22/2012 11:22 AM, Ohad Ben-Cohen wrote:
> Hi Ludovic,
>
> On Tue, May 22, 2012 at 12:14 PM, frq09524<ludovic.barre@stericsson.com>  wrote:
>> Ohad, for alignment I can take the latest branch of kernel.org (remoteproc)
>> branch for-next?
>
> Sure, it's pretty much updated sans a few simple changes.
>
> Thanks,
> Ohad.

