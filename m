Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab2CFLT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:19:57 -0500
Received: from smtp22.mail.ru ([94.100.176.175]:34090 "EHLO smtp22.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759012Ab2CFLTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:19:55 -0500
Date: Tue, 6 Mar 2012 15:19:51 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Andi <andi.shyti@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, Mike Rapoport <mike@compulab.co.il>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH/RFC 2/2] arm/tegra: add timeout to PCIe PLL lock
 detection loop
Message-ID: <20120306111951.GA8494@rainbow>
References: <1331023544-6439-1-git-send-email-mad_soft@inbox.ru>
 <1331023544-6439-3-git-send-email-mad_soft@inbox.ru>
 <CANndwHav6JcqNOuOXcD1dSNUmVYAV=MJ+y+ud6202q6Dh42Vgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANndwHav6JcqNOuOXcD1dSNUmVYAV=MJ+y+ud6202q6Dh42Vgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:38 Tue 06 Mar     , Andi wrote:
> Hi,
> 
> On Tue, Mar 6, 2012 at 9:45 AM, Dmitry Artamonow <mad_soft@inbox.ru> wrote:
> >        /* Wait for the PLL to lock */
> > +       timeout = 2000;
> >        do {
> >                val = pads_readl(PADS_PLL_CTL);
> > +               mdelay(1);
> 
> why are you using an mdelay? If you need to sleep 1ms just use
> usleep_range or similar

This driver uses mdelay(1) in other places, so I just used it for the sake
of consistency. And as this code runs just one time on boot, there's not
really much harm in doing delay with busy loop instead of sleeping.

Anyway, I agree that sleeping is better than busy waiting in general, so
I can respin this patch using usleep_range, or else prepare incremental
patch on top of this, which will change all mdelay in driver to usleep_range.

-- 
Best regards,
Dmitry "MAD" Artamonow

