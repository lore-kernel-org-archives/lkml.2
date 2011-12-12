Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab1LLIQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 03:16:34 -0500
Received: from [213.157.87.50] ([213.157.87.50]:47093 "EHLO bitmer.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab1LLIQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 03:16:32 -0500
Message-ID: <4EE5B816.4060607@bitmer.com>
Date: Mon, 12 Dec 2011 10:15:18 +0200
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Commit 09d28d2c19 introduces set-after-free in arch/arm/mach-omap2/mcbsp.c
References: <20111211170813.02fd478a@notabene.brown>
In-Reply-To: <20111211170813.02fd478a@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2011 08:08 AM, NeilBrown wrote:
> Should these settings just be moved up before the call to
> omap_device_build_ss?? Doing that removes 
> [    0.196014] Slab corruption: size-32 start=ded3edc0, len=32
> warning.
>
Good catch! Yes, they must be set before omap_device_build_ss and
definitely before kfree. I just wonder how did I managed to put them
after both. Perhaps my own rebasing error or just plain stupidity...
I'll send a patch soon.

-- 
Jarkko
