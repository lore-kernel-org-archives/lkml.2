Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0JWB7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 21:59:40 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:24182 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756182Ab0JWB7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 21:59:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAMvdwUxLd/sX/2dsb2JhbAAHgxjKWpF3gSKDMnQEj08
X-IronPort-AV: E=Sophos;i="4.58,226,1286164800"; 
   d="scan'208";a="80464326"
Message-ID: <4CC24186.1040001@teksavvy.com>
Date: Fri, 22 Oct 2010 21:59:34 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: sata_mv and Highpoint RocketRAID 230x, corruption?
References: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>
In-Reply-To: <AANLkTik02CcVyzn+fMH+VxuUmwwNLZq9qM0MPz81E+1h@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-10-20 04:03 PM, Mathias Burén wrote:
..
> I'm currently not using the BIOS of the raid controller for anything
> else then staggered disk spinup. The HDD partitions start at sector
> 2048 (to get a 1MB alignment since they're 4k sector drives, WD20EARS)
> and end at the last sector.
> What I'm worried about is the corruption mentioned in dmesg, is this
> explained somewhere in more detail? Google didn't reveal much. Am I in
> danger?

Yes.  Just repartition the drives to avoid the final 2GB of each drive,
and then you'll be safe.

The RocketRaid BIOS that I examined here a couple of years ago,
liked to write "metadata" over top of whatever was in certain sectors
near the end of the drive.  EVEN FOR NON-RAID DRIVES.

I think it was the last even (power-of-two) multiple of 1GB or something,
so if you leave the final 2GB untouched, you're guaranteed to avoid it.

Thus the recommendation.

Cheers
