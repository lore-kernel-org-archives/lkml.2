Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab2KIRep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:34:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58437 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2KIReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:34:44 -0500
Message-ID: <509D3EB1.8040703@wwwdotorg.org>
Date: Fri, 09 Nov 2012 10:34:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>,
        Mark Zhang <markz@nvidia.com>
Subject: Re: [PATCH 0/2] Device tree updates for host1x support
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 06:20 AM, Thierry Reding wrote:
> This set of patches are in preparation for the Tegra DRM driver. They
> add the necessary nodes to the DTSI files and setup the clocks necessary
> for host1x and the display controllers to work properly. The AUXDATA
> table is updated with the entries for the newly added nodes and the PLL
> frequency tables are extended with some frequencies required to make a
> few of the more common LVDS panel and HDMI display modes work.
> 
> By default, all output resources (RGB, HDMI, DSI and TVO) are disabled,
> and individual boards need to enable those that they require.
> 
> Note that there has been talk to replace the frequency tables by an
> algorithmic computation of the dividers in order to avoid endless
> additions to these tables. No code has surfaced yet, but eventually this
> should replace the static tables.

This basically looks reasonable.

I assume the DT bindings are documented in the tegradrm driver series? I
haven't looked at that yet.

I'd like to see explicit acks for the DT changes from e.g. Terje and
Mark Zhang, and anyone else involved in previous discussions about them.

Could you please split up the patches a little differently? I'd like to see:

1) Changes to the clock driver
2) Changes to add AUXDATA
3) Changes to .dts files

The reason being that these are logically separate changes. (1) and (2)
would be applied to the "soc" branch, and (3) to the "dt" branch.

Finally, I'd prefer not to rename the match parameters in the clock
drivers any more; just set up the AUXDATA to match whatever driver names
the clock driver is expecting. That will reduce churn to the clock
driver. I really hope soon that Tegra will support DT bindings for
clocks so we can get rid of the AUXDATA, but unfortunately I haven't
seen any movement towards this:-(

Thanks.
