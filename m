Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0HCLPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 07:15:36 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44858 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641Ab0HCLPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 07:15:35 -0400
Message-ID: <4C57FA57.2000601@kernel.dk>
Date: Tue, 03 Aug 2010 13:15:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: stable@kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2 block#for-2.6.36] bio, fs: update RWA_MASK, READA
 and  SWRITE to match the corresponding BIO_RW_* bits
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D397.8010305@kernel.org> <4C5724E8.9010204@kernel.dk> <4C57E722.5060809@kernel.org>
In-Reply-To: <4C57E722.5060809@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-03 11:53, Tejun Heo wrote:
> Commit a82afdf (block: use the same failfast bits for bio and request)
> moved BIO_RW_* bits around such that they match up with REQ_* bits.
> Unfortunately, fs.h hard coded RW_MASK, RWA_MASK, READ, WRITE, READA
> and SWRITE as 0, 1, 2 and 3, and expected them to match with BIO_RW_*
> bits.  READ/WRITE didn't change but BIO_RW_AHEAD was moved to bit 4
> instead of bit 1, breaking RWA_MASK, READA and SWRITE.
> 
> This patch updates RWA_MASK, READA and SWRITE such that they match the
> BIO_RW_* bits again.  A follow up patch will update the definitions to
> directly use BIO_RW_* bits so that this kind of breakage won't happen
> again.
> 
> Neil also spotted missing RWA_MASK conversion.
> 
> Stable: The offending commit a82afdf was released with v2.6.32, so
> this patch should be applied to all kernels since then but it must
> _NOT_ be applied to kernels earlier than that.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-and-bisected-by: Vladislav Bolkhovitin <vst@vlnb.net>
> Root-caused-by: Neil Brown <neilb@suse.de>
> Cc: Jens Axobe <axboe@kernel.dk>
           ^^^^^

(Too) common typo :-)

Anyway, applied to for-2.6.36, thanks a lot.

-- 
Jens Axboe

