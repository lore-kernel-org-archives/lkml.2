Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1J0Ljz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 07:39:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44063 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab1J0Ljy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 07:39:54 -0400
Date: Thu, 27 Oct 2011 13:38:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steffen Persvold <sp@numascale.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2/3] Add multi-node boot support
Message-ID: <20111027113819.GA19682@elte.hu>
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
 <1319609230-18897-2-git-send-email-daniel@numascale-asia.com>
 <20111027073029.GD15923@elte.hu>
 <4EA93699.9000101@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA93699.9000101@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steffen Persvold <sp@numascale.com> wrote:

> > If it's absolutely needed then add a proper quirk handler instead 
> > of polluting the generic code.
> 
> We wanted to reuse as much of the generic AMD code as possible, but 
> it's tricky because most of that code is based around a single HT 
> fabric design, whereas a NumaChip based systems consists of several 
> HT fabrics connected together thus you will have identical 
> NorthBridge IDs (0-7) etc. shared between all systems.
> 
> How would you suggest we add a quirk handler for it ?

So what we want on NumaChip systems is for the node ID in the BIOS 
SRAT table to override the node ID that is read from the hardware, 
right?

Instead of making it a is_numachip_system() thing it would be better 
to detect that the two do not match, and override it if the platform 
says that we should override it - and warn about the mismatch 
otherwise.

Whether to override could be a new srat_override() function in the 
x86_init structure or so.

Thomas, Peter, what do you think?

Thanks,

	Ingo
