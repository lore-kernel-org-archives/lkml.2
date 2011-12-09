Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1LIGRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 01:17:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57611 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab1LIGRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 01:17:49 -0500
Date: Fri, 9 Dec 2011 07:16:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/2] x86, MCE: Catch the early worm
Message-ID: <20111209061601.GB24537@elte.hu>
References: <1323353332-5671-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323353332-5671-1-git-send-email-bp@amd64.org>
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


* Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Currently, we don't decode MCEs which are being detected during MCA
> initialization and before registration of the decoders on the decoding
> notifier chain. These two patches add the functionality to drain the
> mcelog buffer right after we've registered a decoder.
> 
> With it, early MCEs get caught and decoded into the dmesg:
> 
> ...
> [    0.068003] ... generic registers:      6
> [    0.068003] ... value mask:             0000ffffffffffff
> [    0.068003] ... max period:             00007fffffffffff
> [    0.068003] ... fixed-purpose events:   0
> [    0.068003] ... event mask:             000000000000003f
> [    0.068003] MCE: In-kernel MCE decoding enabled.
> [    0.068003] [Hardware Error]: CPU:0  MC0_STATUS[-|UE|MiscV|-|AddrV|-|-]: 0xac80000000000833
> [    0.068003] [Hardware Error]:        MC0_ADDR: 0x00000000f8080000
> [    0.068003] [Hardware Error]: Data Cache Error: System Read Data Error.
> [    0.068003] [Hardware Error]: cache level: L3/GEN, mem/io: MEM, mem-tx: DRD, part-proc: SRC (no timeout)
> [    0.068069] Booting Node   0, Processors  #1
> [    0.068276] smpboot cpu 1: start_ip = 88000
> [    0.160077]  #2
> [    0.160206] smpboot cpu 2: start_ip = 88000
> [    0.252073]  #3 Ok.
> ...
> 
> Comments and suggestions are welcome, as always.

Looks good to me.

Thanks,

	Ingo
