Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab0HESq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab0HESq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:46:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@kernel.dk>, stable@kernel.org,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH RESEND 1/2 block#for-linus] bio, fs: update READA and SWRITE to match the corresponding BIO_RW_* bits
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>
	<4C28EFD6.2070203@vlnb.net>
	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>
	<4C3EF3AD.5070509@vlnb.net>
	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>
	<4C4D7DF5.9060909@vlnb.net>
	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>
	<4C5073F3.1060406@vlnb.net> <4C52A98A.7060507@kernel.org>
	<20100802104227.79340b49@notabene> <4C56D30A.3000403@kernel.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 05 Aug 2010 14:45:33 -0400
In-Reply-To: <4C56D30A.3000403@kernel.org> (Tejun Heo's message of "Mon, 02
	Aug 2010 16:15:38 +0200")
Message-ID: <x49y6ckc302.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Commit a82afdf (block: use the same failfast bits for bio and request)
> moved BIO_RW_* bits around such that they match up with REQ_* bits.
> Unfortunately, fs.h hard coded READ, WRITE, READA and SWRITE as 0, 1,
> 2 and 3, and expected them to match with BIO_RW_* bits.  READ/WRITE
> didn't change but BIO_RW_AHEAD was moved to bit 4 instead of bit 1,
> breaking READA and SWRITE.
>
> This patch updates READA and SWRITE such that they match the BIO_RW_*
> bits again.  A follow up patch will update the definitions to directly
> use BIO_RW_* bits so that this kind of breakage won't happen again.
>
> Stable: The offending commit a82afdf was released with v2.6.32, so
> this patch should be applied to all kernels since then but it must
> _NOT_ be applied to kernels earlier than that.

Would someone be so kind as to remind me how this problem manifests
itself?  I know I read this recently, but my memory and googling skills
are both failing me.  :(

Cheers,
Jeff
