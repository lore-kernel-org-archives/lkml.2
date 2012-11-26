Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab2KZKF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:05:26 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:33578 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab2KZKFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:05:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Mon, 26 Nov 2012 11:10:09 +0100
Message-ID: <1809962.ISd4pqTkPA@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121126170919.f7009838d3126e547205a705@canb.auug.org.au>
References: <20121126170919.f7009838d3126e547205a705@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 05:09:19 PM Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/devfreq/governor_simpleondemand.c: In function 'devfreq_simple_ondemand_func':
> drivers/devfreq/governor_simpleondemand.c:36:11: error: dereferencing pointer to incomplete type
> drivers/devfreq/governor_simpleondemand.c:37:27: error: dereferencing pointer to incomplete type
> drivers/devfreq/governor_simpleondemand.c:38:11: error: dereferencing pointer to incomplete type
> drivers/devfreq/governor_simpleondemand.c:39:32: error: dereferencing pointer to incomplete type
> 
> Caused by commit eff607fdb1f7 ("PM / devfreq: governors: add GPL module
> license and allow module build").  The definition of struct
> devfreq_simple_ondemand_data depends on
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND, but this is a modular build, so
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND_MODULE is defined instead.
> 
> I have used the pm tree fomr next-20121115 for today.

Sorry for the breakage, I've dropped the most recent devfreq patches from
my linux-next branch for now.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
