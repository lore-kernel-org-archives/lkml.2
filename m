Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0HBUE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:04:58 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54609 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab0HBUE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:04:57 -0400
Message-ID: <4C5724E8.9010204@kernel.dk>
Date: Mon, 02 Aug 2010 22:04:56 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: stable@kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH RESEND 1/2 block#for-linus] bio, fs: update READA and
 SWRITE  to match the corresponding BIO_RW_* bits
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D397.8010305@kernel.org>
In-Reply-To: <4C56D397.8010305@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 04:17 PM, Tejun Heo wrote:
> Aieee... thanks for root causing it Neil.  That was a stupid bug.  I
> knew that READ/WRITE were hardcoded but forgot about READA.  :-(
> Moving BIO_RW_AHEAD back to bit 1 might be a better solution but I'm
> afraid that would cause more confusions downstream.  This patch
> updates READA and SWRITE to match BIO_RW_AHEAD and should also appear
> in -stable releases.  The next patch will create bio_types.h and
> define all constants in terms of BIO_RW_*.

Tejun, care to resend these against for-2.6.36? We can reference
these for the stable backport (at least the first one should go in).

-- 
Jens Axboe

