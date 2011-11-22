Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1KVNHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:07:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60702 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1KVNHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:07:49 -0500
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
Date: Tue, 22 Nov 2011 13:07:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, aul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, eric.miao@linaro.org, richard.zhao@linaro.org,
        Mike Turquette <mturquette@linaro.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org> <1321926047-14211-6-git-send-email-mturquette@linaro.org>
In-Reply-To: <1321926047-14211-6-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111221307.14942.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:rtDncy4fAnOELNLXKLM3GSQojM1uG4HC1xwC/bwZdw2
 P7O2lmqzHD7fDRVsGVjNVeYj/zE++VVjm6oah+atSpbUT/NJDZ
 xjoOBICLNJ9t3BhB9uIumEwjW0J6ijmxSkrooIDGWXn1XP0faX
 el/lvLw0uKE/OObsq1GUq2dSlmQG28pnBEoIdTPH6nFzXbdI7t
 HZpy0szFXf1XQzBPr17S4tzMKsOj/0v9RhXFFx/bPXBMU/oJGu
 RbaWxPfyYcQs29IB7Ok6IwP28RAqK74HPrSee2oZP/LHmMh4hO
 SExdffm9C63AgyNWGMzFkgpMKpyAleZ8W3YBZloJXPbRxuPlnJ
 WSZ/DvnXKaUtYv7ES/5EWWUuHtl+iQqLl/B76qblW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 November 2011, Mike Turquette wrote:
> Introduces kobject support for the common struct clk, exports per-clk
> data via read-only callbacks and models the clk tree topology in sysfs.
> 
> Also adds support for generating the clk tree in clk_init and migrating
> nodes when input sources are switches in clk_set_parent.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
>  drivers/clk/Kconfig     |   10 +++
>  drivers/clk/Makefile    |    1 +
>  drivers/clk/clk-sysfs.c |  199 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/clk/clk.c       |    5 +-
>  include/linux/clk.h     |   36 ++++++++-
>  5 files changed, 248 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/clk/clk-sysfs.c

Since this introduces a new top-level hierarchy in sysfs, it certainly needs
to be reviewed by Greg K-H (on Cc now). Also, you have to add a proper
documentation for every new node and attribute in Documentation/ABI along
with the code.

> +static struct kobject *clk_kobj;
> +LIST_HEAD(kobj_list);

The list head should be static.

	Arnd
