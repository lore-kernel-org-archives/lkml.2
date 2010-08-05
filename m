Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab0HES5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:57:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52351 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab0HES5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:57:31 -0400
Message-ID: <4C5B0994.1070203@vlnb.net>
Date: Thu, 05 Aug 2010 22:57:24 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@kernel.dk>,
        stable@kernel.org, Bryan Mesich <bryan.mesich@ndsu.edu>,
        scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH RESEND 1/2 block#for-linus] bio, fs: update READA and
 SWRITE to match the corresponding BIO_RW_* bits
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net> <4C52A98A.7060507@kernel.org>	<20100802104227.79340b49@notabene> <4C56D30A.3000403@kernel.org> <x49y6ckc302.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49y6ckc302.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:1dUtCQaD4wM7/ypSeSjLHQU9kQGdJIV8sZkTK/9ABF5
 UVd3u5e1kgUHB+eo9CZajwHo5Fxx34uovQ8H70tUrdAlr136n5
 /GD0K/WTVq+wVsaNOoIoqK100PgfDTygHHp2QDTv0eRnE9cbE4
 w2QBOMrh7bQf3BaWxT/5ci/Ked0sGfSqk2uUAzElnt2WI8167h
 7BrdxZAko5MgOzNxS+EZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jeff Moyer, on 08/05/2010 10:45 PM wrote:
> Tejun Heo<tj@kernel.org>  writes:
>
>> Commit a82afdf (block: use the same failfast bits for bio and request)
>> moved BIO_RW_* bits around such that they match up with REQ_* bits.
>> Unfortunately, fs.h hard coded READ, WRITE, READA and SWRITE as 0, 1,
>> 2 and 3, and expected them to match with BIO_RW_* bits.  READ/WRITE
>> didn't change but BIO_RW_AHEAD was moved to bit 4 instead of bit 1,
>> breaking READA and SWRITE.
>>
>> This patch updates READA and SWRITE such that they match the BIO_RW_*
>> bits again.  A follow up patch will update the definitions to directly
>> use BIO_RW_* bits so that this kind of breakage won't happen again.
>>
>> Stable: The offending commit a82afdf was released with v2.6.32, so
>> this patch should be applied to all kernels since then but it must
>> _NOT_ be applied to kernels earlier than that.
>
> Would someone be so kind as to remind me how this problem manifests
> itself?  I know I read this recently, but my memory and googling skills
> are both failing me.  :(

See http://lkml.org/lkml/2010/7/28/315 and link inside.

Vlad
