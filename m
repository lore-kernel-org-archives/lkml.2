Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1ACQBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:01:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43259 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab1ACQBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:01:19 -0500
Message-ID: <4D21F2C1.30500@zytor.com>
Date: Mon, 03 Jan 2011 08:01:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-kernel@vger.kernel.org,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: Loss of PAT-WC after resume on i5
References: <849307$b076ne@azsmga001.ch.intel.com>
In-Reply-To: <849307$b076ne@azsmga001.ch.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 04:14 AM, Chris Wilson wrote:
> We have noticed that graphics may become very slow after suspend & resume.
> One effect that we have clearly identified is that writing through the GTT
> becomes very slow:
> 
> Before suspending:
>   Time to pwrite 16k through the CPU:               4Âµs
>   Time to read 16k through a GTT map:             901Âµs
>   Time to write 16k through a GTT map:             23Âµs
>   Time to read 16k (again) through a GTT map:     900Âµs
>   Time to pwrite 16k through the GTT:               7Âµs
> 
> After resume:
>   Time to pwrite 16k through the CPU:               4Âµs
>   Time to read 16k through a GTT map:             900Âµs
>   Time to write 16k through a GTT map:            876Âµs
>   Time to read 16k (again) through a GTT map:     899Âµs
>   Time to pwrite 16k through the GTT:             431Âµs
> 
> Presuming that it was the loss of the WC mapping, I tore down and
> recreated the ioremap_wc upon resume which restored performance back to
> normal.
> 
> So could we indeed be failing to restore the PAT caching state upon
> resume?
> 

Sounds like it.  It sounds based on your description that it's something
more fundamental than just the state of the PAT MSR being lost, too,
although perhaps that's the first thing to check...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

