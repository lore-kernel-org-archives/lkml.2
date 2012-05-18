Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339Ab2ERHtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:49:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47619 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760926Ab2ERHt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:49:29 -0400
Date: Fri, 18 May 2012 08:49:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/6] mmc: dw_mmc: lookup for optional biu and ciu
	clocks
Message-ID: <20120518074901.GA843@n2100.arm.linux.org.uk>
References: <1337267411-28226-1-git-send-email-thomas.abraham@linaro.org> <1337267411-28226-4-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337267411-28226-4-git-send-email-thomas.abraham@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 08:40:08PM +0530, Thomas Abraham wrote:
> +err_clk:
> +	if (!IS_ERR(host->ciu_clk))
> +		clk_disable_unprepare(host->ciu_clk);
> +	if (!IS_ERR(host->biu_clk))
> +		clk_disable_unprepare(host->biu_clk);
> +	clk_put(host->ciu_clk);
> +	clk_put(host->biu_clk);

+	if (!IS_ERR(host->ciu_clk)) {
+		clk_disable_unprepare(host->ciu_clk);
+		clk_put(host->ciu_clk);
+	}
+	if (!IS_ERR(host->biu_clk)) {
+		clk_disable_unprepare(host->biu_clk);
+		clk_put(host->biu_clk);
+	}

And the same in the other occurrence.
