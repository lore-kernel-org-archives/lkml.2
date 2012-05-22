Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab2EVICk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:02:40 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58932 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab2EVICg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:02:36 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.15.47]
In-Reply-To: <CAHTX3dK8rDomYqWvBX1ay200AmM1dBCYD3nJ2UYbzC_SSFankw@mail.gmail.com>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
 <1330589497-4139-2-git-send-email-ohad@wizery.com> <4F6354E4.8030704@monstr.eu>
 <CAK=Wgbbbi4GnuHedSh6cR1LhkZr8c9q6i=_TLSL252LpPB8Xsw@mail.gmail.com>
 <CAK=WgbYeQr5ZwTSBo+ZJUzN7fQ--0QbC8HSjrGT-Geycs4SKcg@mail.gmail.com>
 <CAHTX3d+=QTZo994jct6+pPqsCniG0B2a_9q6fLdGjvcbZ7qj_A@mail.gmail.com>
 <CAK=WgbahzGHmvszw6HBgihN4NcPA8ceaQCNSOk_FC61bToxBXQ@mail.gmail.com> <CAHTX3dK8rDomYqWvBX1ay200AmM1dBCYD3nJ2UYbzC_SSFankw@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 22 May 2012 11:02:14 +0300
Message-ID: <CAK=WgbYSrzTKW-QME4-r6XhVAQL0b6iWyus632KZOpfpTPgwWg@mail.gmail.com>
Subject: Re: [PATCH 1/7] remoteproc: resource table overhaul
To: Michal Simek <monstr@monstr.eu>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Tue, May 22, 2012 at 8:51 AM, Michal Simek <monstr@monstr.eu> wrote:
> Simple enabling RSC_VDEV in rproc_handle_rsc doesn't work.

Sure - you'll need to actually plug the vrings allocation code there,
too (i.e. this requires some coding, it's not a 1-liner).

> BTW: I am using kernel modules and there is no dependency for
> virtio_rpmsg_bus in remoteproc module
> in sense if you load remoteproc module you also need to load
> virtio_rpmsg_bus to get firmware to work.

This is expected: remoteproc only provides means for booting and
controlling remote processors and it doesn't boot them upfront.

To actually boot a remote processor, and do something useful with it,
one needs to load a module which utilizes remoteproc's API (e.g.
virtio_rpmsg_bus, but YMMV).

> ~ # lsmod
> ~ # modprobe zynq_remoteproc
> zynq_remoteproc: Unknown symbol rproc_register (err 0)
> zynq_remoteproc: Unknown symbol rproc_alloc (err 0)
> zynq_remoteproc: Unknown symbol rproc_vq_interrupt (err 0)
> zynq_remoteproc: Unknown symbol rproc_free (err 0)
> zynq_remoteproc: Unknown symbol rproc_unregister (err 0)

We don't have these errors - have you tried looking into them ?

Btw do you plan on submitting the code for zynq_remoteproc ?

> Can you see the same behavior on omap?

Except the "Unknown symbol" errors, everything else looks good.

Thanks,
Ohad.
