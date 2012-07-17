Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2GQNeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:34:22 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:47991 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891Ab2GQNeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:34:21 -0400
Message-ID: <500569D5.3020508@ti.com>
Date: Tue, 17 Jul 2012 19:04:13 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Mike Turquette <mturquette@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, aletes.xgr@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Archit Taneja <archit@ti.com>, loml <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, "Cousson, Benoit" <b-cousson@ti.com>
Subject: Re: [PATCH] clk: fix compile for OF && !COMMON_CLK
References: <1342475161-20402-1-git-send-email-robherring2@gmail.com> <20120717001228.GA28886@gmail.com> <5004C935.4050707@gmail.com> <50056648.6000906@ti.com>
In-Reply-To: <50056648.6000906@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012 06:49 PM, Rajendra Nayak wrote:
> struct clk *clk_get(struct device *dev, const char *con_id)
> {
>          const char *dev_id = dev ? dev_name(dev) : NULL;
>          struct clk *clk;
>
>          if (dev) {
> ---->
>      Any reason why this isn't
>      if (dev->of_node) {
> ---->

Or rather,
	if (dev && dev->of_node) {
as Archit just pointed out to me.
