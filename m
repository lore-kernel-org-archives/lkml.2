Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2ADSjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:39:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48145 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab2ADSjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:39:19 -0500
Date: Wed, 4 Jan 2012 19:37:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Add Dell Studio 1557 to pci=nocrs blacklist
Message-ID: <20120104183712.GB14966@elte.hu>
References: <20111230193704.GA2874@redhat.com>
 <20120101145354.GA1791@elte.hu>
 <20120103093020.0cbcd735@jbarnes-desktop>
 <CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
 <20120104163311.GB31667@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104163311.GB31667@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Jones <davej@redhat.com> wrote:

> The Dell Studio 1557 also doesn't suspend correctly when CRS is enabled.
> Details at https://bugzilla.redhat.com/show_bug.cgi?id=769657
> 
> Reported-by: Gregory S. Hoerner <ghoerner@transcendingthought.com>
> Signed-off-by: Dave Jones <davej@redhat.com>
>  
> --- linux-3.1.noarch/arch/x86/pci/acpi.c~	2012-01-04 11:19:36.783664477 -0500
> +++ linux-3.1.noarch/arch/x86/pci/acpi.c	2012-01-04 11:23:42.403666272 -0500
> @@ -75,6 +75,16 @@ static const struct dmi_system_id pci_us
>  	/* https://bugzilla.redhat.com/show_bug.cgi?id=769657 */
>  	{
>  		.callback = set_nouse_crs,
> +		.ident = "Dell Studio 1557",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1557");
> +			DMI_MATCH(DMI_BIOS_VERSION, "A09"),

Btw., should we perhaps match on all things 'Studio*'? For these 
two systems i'm sure there's 20 other models we have not covered 
yet ...

Thanks,

	Ingo
