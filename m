Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab1L1SRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 13:17:14 -0500
Received: from mail.vyatta.com ([76.74.103.46]:48731 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab1L1SRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 13:17:13 -0500
Date: Wed, 28 Dec 2011 10:17:10 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Roger Luethi <rl@hellgate.ch>
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on
 low-end broads.
Message-ID: <20111228101710.51c4893f@nehalam.linuxnetplumber.net>
In-Reply-To: <CACPM=kX2hcGt3XXDJkCAcOjv=5oqSHChhhphUAyRhR_PsNFEEQ@mail.gmail.com>
References: <1325075319-13464-1-git-send-email-gurligebis@gentoo.org>
	<1325083051.2327.47.camel@deadeye>
	<CACPM=kWpGnBOuKPUK9MgzyETe4VmvEtVXkYtPA_+Xgn=COkCPw@mail.gmail.com>
	<1325092423.2327.70.camel@deadeye>
	<CACPM=kX2hcGt3XXDJkCAcOjv=5oqSHChhhphUAyRhR_PsNFEEQ@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the hardware isn't really disabling interrupts correctly to support
NAPI. NAPI is supposed to be friendly and under load the work should move to
ksoftirqd. I suspect the IRQ management in this driver is borked.
There is some stupid spin loops in the IRQ handler that happen when looking for
Tx IRQ. I would run with debug set  and see if this is triggering.
