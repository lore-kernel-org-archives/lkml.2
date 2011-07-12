Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1GLEX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 00:23:28 -0400
Received: from mail.perches.com ([173.55.12.10]:3898 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab1GLEX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 00:23:27 -0400
Subject: Re: Checkpatch.pl generates false alarm
From: Joe Perches <joe@perches.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: apw@canonical.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4E1B0D51.4000905@broadcom.com>
References: <4E1B0D51.4000905@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jul 2011 21:23:26 -0700
Message-ID: <1310444606.6925.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 16:48 +0200, Roland Vossen wrote:
> Hello Andy,
> 
> when I feed attached file to checkpatch, several warnings are given, but 
> this one:
> 
> WARNING: externs should be avoided in .c files
> #3555: FILE: staging/brcm80211/brcmsmac/main.c:3555:
> +       END_FOREACH_BSS
> 
> does not seem to make sense. When I place a comment behind the 
> END_FOREACH_BSS line, the checkpatch warning disappears.
> 
> Let me know if you need additional info to work on this.

I think this code is bad form and confuses checkpatch:

	/* update the capability based on current shortslot mode */
	FOREACH_BSS(wlc, idx, cfg)
		if (!cfg->associated)
			continue;
		cfg->current_bss->capability &=
					~WLAN_CAPABILITY_SHORT_SLOT_TIME;
		if (wlc->shortslot)
			cfg->current_bss->capability |=
					WLAN_CAPABILITY_SHORT_SLOT_TIME;
	END_FOREACH_BSS

I think this code is still slightly bad form, but it isn't a problem
for checkpatch:

	/* update the capability based on current shortslot mode */
	FOREACH_BSS(wlc, idx, cfg) {
		if (!cfg->associated)
			continue;
		cfg->current_bss->capability &=
					~WLAN_CAPABILITY_SHORT_SLOT_TIME;
		if (wlc->shortslot)
			cfg->current_bss->capability |=
					WLAN_CAPABILITY_SHORT_SLOT_TIME;
	} END_FOREACH_BSS


