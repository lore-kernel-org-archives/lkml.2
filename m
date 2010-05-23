Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0EWSdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 14:33:00 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:59720 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab0EWSc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 14:32:59 -0400
Message-ID: <4BF974D5.30207@cesarb.net>
Date: Sun, 23 May 2010 15:32:53 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 0/3] mm: Swap checksum
References: <4BF81D87.6010506@cesarb.net> <20100523140348.GA10843@barrios-desktop>
In-Reply-To: <20100523140348.GA10843@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 23-05-2010 11:03, Minchan Kim escreveu:
> On Sat, May 22, 2010 at 03:08:07PM -0300, Cesar Eduardo Barros wrote:
>> Add support for checksumming the swap pages written to disk, using the
>> same checksum as btrfs (crc32c). Since the contents of the swap do not
>> matter after a shutdown, the checksum is kept in memory only.
>>
>> Note that this code does not checksum the software suspend image.
> We have been used swap pages without checksum.
>
> First of all, Could you explain why you need checksum on swap pages?
> Do you see any problem which swap pages are broken?

The same reason we need checksums in the filesystem.

If you use btrfs as your root filesystem, you are protected by checksums 
from damage in the filesystem, but not in the swap partition (which is 
often in the same disk, and thus as vulnerable as the filesystem). It is 
better to get a checksum error when swapping in than having a silently 
corrupted page.

If you add checksums to the swap, the only piece missing (besides the 
partition table and bootloader, and the first one is solved by GPT, 
which also has a checksum) is checksumming the software suspend image. 
But it has a differente read/write path and different requirements (to 
start with, the checksums must be written to the disk too, while for the 
swap they can stay in memory only).

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
