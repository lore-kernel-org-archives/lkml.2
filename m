Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0G3KaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:30:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:47654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab0G3KaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:30:01 -0400
Message-ID: <4C52A98A.7060507@kernel.org>
Date: Fri, 30 Jul 2010 12:29:30 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
Subject: Re: RAID/block regression starting from 2.6.32, bisected
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net> <20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu> <4C5073F3.1060406@vlnb.net>
In-Reply-To: <4C5073F3.1060406@vlnb.net>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Jul 2010 10:29:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/28/2010 08:16 PM, Vladislav Bolkhovitin wrote:
> In recent kernels we are experiencing a problem that in our setup
> using SCST BLOCKIO backend some BIOs are finished, i.e. the finish
> callback called for them, with error -EIO. It happens quite often,
> much more often than one would expect to have an actual IO
> error. (BLOCKIO backend just converts all incoming SCSI commands to
> the corresponding block requests.)
> 
> After some investigation, we figured out, that, most likely,
> raid5.c::make_request() for some reason sometimes calls bio_endio()
> with not BIO_UPTODATE bios.
> 
> We bisected it to commit: 
> 
> commit a82afdfcb8c0df09776b6458af6b68fc58b2e87b
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri Jul 3 17:48:16 2009 +0900
> 
>     block: use the same failfast bits for bio and request

That commit doesn't (or at least isn't supposed to) make any behavior
difference.  It's just repositioning flag bits.  If the commit is
actually causing the problem, I think one possibility is that whatever
code could be using hard coded constants which now are mapped to
different flags.  The mixed merge changes have been in mainline for
quite some time and shipping in all major distros too and this is the
first time this is reported, so I don't think it could be a widespread
problem.

Thanks.

-- 
tejun
