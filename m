Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1AXXa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:30:57 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:49075 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615Ab1AXXa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:30:57 -0500
Message-ID: <4D3E0BAE.6090202@lougher.demon.co.uk>
Date: Mon, 24 Jan 2011 23:30:54 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SquashFS, XZ: Don't use uninitialized variable in squashfs_xz_uncompress
References: <alpine.LNX.2.00.1101202140070.11854@swampdragon.chaosbits.net> <20110124144353.c04c77b4.akpm@linux-foundation.org>
In-Reply-To: <20110124144353.c04c77b4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/11 22:43, Andrew Morton wrote:
> On Thu, 20 Jan 2011 21:53:23 +0100 (CET)
> Jesper Juhl<jj@chaosbits.net>  wrote:
>
>> In fs/squashfs/xz_wrapper.c::squashfs_xz_uncompress() we have this code:
>>
>> 	enum xz_ret xz_err;
>> 	...
>> 	do {
>> 		if (stream->buf.in_pos == stream->buf.in_size&&  k<  b) {
>> 		... [nothing that assigns to 'xz_err'] ...
>> 			if (avail == 0) {
>> 				offset = 0;
>> 				put_bh(bh[k++]);
>> 				continue;
>
> hm, maybe.  The handling of the `avail == 0' case looks odd.  It sits
> there in a loop doing wait_on_buffer() against buffers which it will
> never use and possible reporting -EIO for a buffer which it didn't use,
> which seems bogus.

Hi Andrew,

I'm just about to send out a patch that fixes this uninitialised variable
bug by way of getting rid of that if (avail == 0) case.

The avail == 0 case is a workaround for the fact that the caller code
can occasionally pass a buffer head that has already been
consumed (read offset into buffer head is at the end of the buffer).

Phillip

