Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2K0Fij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 00:38:39 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:55716 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2K0Fih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 00:38:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121127154430.36e87542081a7cc50f80d0f6@canb.auug.org.au>
References: <20121127154430.36e87542081a7cc50f80d0f6@canb.auug.org.au>
Date: Tue, 27 Nov 2012 11:08:36 +0530
Message-ID: <CAKohpo=K2kX-M4NM9onrn-Rr4otJwcQ1HxN5cKPYvj+Tza_0Ug@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the slave-dma tree
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2012 10:14, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-spear13xx/spear1310.c between commit b47394911c26 ("ARM:
> SPEAr13xx: Pass DW DMAC platform data from DT") from the slave-dma tree
> and commit 300a6856324a ("ARM: SPEAr1310: Fix AUXDATA for compact flash
> controller") from the arm-soc tree.
>
> I have no idea how to fix this up, so I just effectively dropped the
> arm-doc tree patch.

Hi Stephen,

So sorry for that, Can you please take arm-soc version here? Patch 300a6856324a
is doing the correct thing. i.e. we need

+       OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, &cf_pdata),

instead of

+       OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, "cf"),

--
viresh
