Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab2EUOQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:16:55 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab2EUOQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:16:54 -0400
Message-ID: <4FBA4E52.8090807@nod.at>
Date: Mon, 21 May 2012 16:16:50 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Subject: Re: [PATCH 1/7] [RFC] UBI: Export next_sqnum()
References: <1337101871-31181-1-git-send-email-richard@nod.at>   <1337101871-31181-2-git-send-email-richard@nod.at>  <1337173272.24809.52.camel@sauron.fi.intel.com> <4FBA4448.20509@nod.at> <1337608854.2483.71.camel@sauron.fi.intel.com>
In-Reply-To: <1337608854.2483.71.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.05.2012 16:00, Artem Bityutskiy wrote:
> On Mon, 2012-05-21 at 15:34 +0200, Richard Weinberger wrote:
>>> +	/* TODO: Before checking version - check the CRC.
>>
>> The CRC covers only the fastmap data, not the super block.
>
> Everything should be protected with CRC.

Okay, done. :)

>>>    	for (i = 0; i<   nblocks; i++) {
>>> +		/* TODO: you basically perform the scanning here - you should
>>> +		 * share the same code as we use in scan.c: use process_peb().
>>> +		 */
>>
>> What exactly do you mean by that?
>> process_eb() will not help much because the fastmap data is written
>> "raw" to the flash. (Without any interaction from the WL sub-system)
>
> It still contains EC and VID headers. So you can use the existing code
> for scanning it.

I use already ubi_io_read_vid_hdr() and ubi_io_read_ec_hdr() what should 
I reuse?
Also checking the image sequence would make sense.

Thanks,
//richard
