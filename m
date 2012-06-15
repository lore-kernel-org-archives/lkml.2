Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2FOPkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:40:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45608 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab2FOPkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:40:12 -0400
Message-ID: <4FDB5756.3010402@wwwdotorg.org>
Date: Fri, 15 Jun 2012 09:40:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, mturquette@linaro.org,
        sboyd@codeaurora.org, skannan@codeaurora.org, s.hauer@pengutronix.de,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v3 0/4] DT clock bindings
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com> <20120615083937.GH31565@S2101-09.ap.freescale.net>
In-Reply-To: <20120615083937.GH31565@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 02:39 AM, Shawn Guo wrote:
> On Tue, Jun 12, 2012 at 09:41:47AM -0500, Rob Herring wrote:
>> I'm posting this again to solicit further review. There has been some
>> discussion[1], but no definite path forward. This series is not changed
>> from the last post other than rebasing to v3.5-rc2.
>>
> Hi Rob,
> 
> Per your comment[1], the patch below takes imx6q as example to define
> single CCM node with a whole bunch of outputs to support clk lookup
> with device tree.  (Only uart and usdhc clocks are being put there for
> demonstration.)  Though it seems working, going through the patch you
> will see a couple problems which may need to be solved to make the
> binding useful for cases like imx.
...
> * phandle argument is not easy for engineering
> 
> As we will have a whole bunch of clock outputs listed in ccm node,
> which will be referenced by peripheral phandle in form of <&clks index>.
> When the list gets long, it becomes hard for people to find the correct
> index number for the clock referenced.

You can (well, probably /should/) list the clock IDs as well as names in
the binding documentation. Then, there's no guess-work or counting
involved. I did this in a very early Tegra clock binding proposal:

http://patchwork.ozlabs.org/patch/141359/

Hopefully, dtc will grow named-constants or a pre-processor sometime and
help this too.
