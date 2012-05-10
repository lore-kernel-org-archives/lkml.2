Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab2EJNoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:44:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38281 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2EJNoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:44:12 -0400
Date: Thu, 10 May 2012 14:43:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: James Hogan <james@albanarts.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] mmc: dw_mmc: lookup for optional biu and ciu clocks
Message-ID: <20120510134342.GA12727@n2100.arm.linux.org.uk>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org> <1335935266-25289-2-git-send-email-thomas.abraham@linaro.org> <CAAG0J9-NDM9wLKpq04ofPkvFqiWxjmP84ojsP9Hfs0SJ_0FaXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAG0J9-NDM9wLKpq04ofPkvFqiWxjmP84ojsP9Hfs0SJ_0FaXg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 03:53:53PM +0100, James Hogan wrote:
> Hi
> 
> On 2 May 2012 06:07, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> > +       if (IS_ERR(host->biu_clk))
> > +               dev_info(&host->dev, "biu clock not available\n");
> 
> In this case, should it set host->biu_clk to NULL or are clk_disable
> and clk_put guaranteed to handle an IS_ERR value?

I keep saying this.  NULL must be treated as a valid reutrn value from
clk_get() and must not use this as a sentinel.  The clk namespace is
that errors are indicated with IS_ERR(clk) returning true.  Everything
else must be assumed to be valid by drivers.
