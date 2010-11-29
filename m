Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab0K2PAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:00:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:41996 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0K2PAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:00:50 -0500
Date: Mon, 29 Nov 2010 16:00:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        "Rafael J. Wysocki" <rjw@suse.com>
Subject: [REGRESSION] Suspend fails because of TPM modules
Message-ID: <alpine.LNX.2.00.1011291554570.981@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on my thinkpad x200s (and I have seen reports on different HW as well), 
suspend fails when TPM modules are loaded.

	tpm_tis 00:0a: tpm_transmit: tpm_send: error -5
	legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -5
	PM: Device 00:0a failed to suspend: error -5
	PM: Some devices failed to suspend

Once tpm, tpm_bios, tpm_tis and tpm modules are unloaded, suspend/resume 
works.

This is a regression. It definitely worked on this very same hardware on 
2.6.34. Any kernel between .34 and .37 wasn't booted there, so I don't 
have any data of that kind.

I can try bisecting it, but if anyone sees immediately what the culprit 
might be, that'd be helpful.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
