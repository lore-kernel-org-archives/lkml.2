Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1FIJiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:38:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52301 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab1FIJiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:38:12 -0400
MIME-Version: 1.0
In-Reply-To: <4DF06E29.4010807@st.com>
References: <4DF06E29.4010807@st.com>
Date: Thu, 9 Jun 2011 11:38:11 +0200
Message-ID: <BANLkTik9kZjJs5H2kvM+xAtd_CR5NA0dDw@mail.gmail.com>
Subject: Re: Why move all map_sg/unmap_sg for slave channel to its client?
From: Linus Walleij <linus.walleij@linaro.org>
To: viresh kumar <viresh.kumar@st.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        anemo@mba.ocn.ne.jp, Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 8:54 AM, viresh kumar <viresh.kumar@st.com> wrote:

> I thought map_sg/unmap_sg for slave channels will be handled according
> to the flags passed in prep_slave_sg(). But then i found following patch:
> (...)
> I don't have much knowledge about that discussion, but i think this should be left
> configurable.
> If the client wants to control map/unmap then it can simply pass
> DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP in flags. I didn't wanted to
> skip this in my driver and so i don't pass them.

What if the same driver is used on many different platforms like say
drivers/tty/serial/amba-pl011.c, and some of the platforms using it
has DMA engines that does not implement mapping/unmapping of
the passed sglist?

In that case I think you have to modify all drivers in drivers/dma/*
to do this mapping, and then you could just make it a required behaviour
and skip the flags altogether.

But apparently that approach was blocked at one point so let's see
what the others say.

Yours,
Linus Walleij
