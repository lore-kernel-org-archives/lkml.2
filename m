Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab0HCPwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:52:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:47234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab0HCPwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:52:39 -0400
Message-ID: <4C583B3B.3060301@kernel.org>
Date: Tue, 03 Aug 2010 17:52:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>, Jan Harkes <jaharkes@cs.cmu.edu>,
        coda@cs.cmu.edu
CC: stable@kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2 block#for-2.6.36] bio, fs: update RWA_MASK, READA
 and  SWRITE to match the corresponding BIO_RW_* bits
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene> <4C56D397.8010305@kernel.org> <4C5724E8.9010204@kernel.dk> <4C57E722.5060809@kernel.org> <4C57FA57.2000601@kernel.dk> <4C57FBAD.1080809@fusionio.com>
In-Reply-To: <4C57FBAD.1080809@fusionio.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 15:52:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing CODA people)
Hello,

On 08/03/2010 01:21 PM, Jens Axboe wrote:
>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>> Reported-and-bisected-by: Vladislav Bolkhovitin <vst@vlnb.net>
>>> Root-caused-by: Neil Brown <neilb@suse.de>
>>> Cc: Jens Axobe <axboe@kernel.dk>
>>            ^^^^^
>>
>> (Too) common typo :-)
>>
>> Anyway, applied to for-2.6.36, thanks a lot.

Oops, I'm sorry.  Heh, it reminds me of misspelling Linus's last name
as Tolvards in a number of patches.  :-)

> Irk, we have an issue:
> 
> In file included from fs/coda/psdev.c:48:
> include/linux/coda_psdev.h:91:1: warning: "REQ_WRITE" redefined
> In file included from include/linux/fs.h:11,
>                  from include/linux/proc_fs.h:5,
>                  from fs/coda/psdev.c:31:
> include/linux/blk_types.h:154:1: warning: this is the location of the previous definition
> 
> And from include/linux/coda_psdev.h:
> 
> #define REQ_ASYNC  0x1
> #define REQ_READ   0x2
> #define REQ_WRITE  0x4
> #define REQ_ABORT  0x8
> 
> which unfortunately seem to not be under __KERNEL__ protection, but
> there are things like wait_queue_head_t structs there as well so should
> be safe to change.

Yeah, I hate it when symbols in non-core code doesn't have proper
prefix.  Prefixing CODA_ in front of those macros should do it.  Jan
Harkes, would that work for CODA?

Thanks.

-- 
tejun
