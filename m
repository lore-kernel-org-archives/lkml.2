Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab0HJDGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 23:06:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62654 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab0HJDGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 23:06:09 -0400
Message-ID: <4C60C236.4000509@vflare.org>
Date: Tue, 10 Aug 2010 08:36:30 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] Replace ioctls with sysfs interface
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>	<1281374816-904-2-git-send-email-ngupta@vflare.org> <AANLkTimuPK=1+xNMKfV=G1sSG60+=fa7eA3142JJZZ6p@mail.gmail.com>
In-Reply-To: <AANLkTimuPK=1+xNMKfV=G1sSG60+=fa7eA3142JJZZ6p@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 12:04 AM, Pekka Enberg wrote:
> On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> Creates per-device sysfs nodes in /sys/block/zram<id>/
>> Currently following stats are exported:
>>  - disksize
>>  - num_reads
>>  - num_writes
>>  - invalid_io
>>  - zero_pages
>>  - orig_data_size
>>  - compr_data_size
>>  - mem_used_total
>>
<snip>
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> 
> Looks good to me (but I'm not a sysfs guy).
> 
> Acked-by: Pekka Enberg <penberg@kernel.org>
> 

Thanks!

>>  /* Module params (documentation at end) */
>> -static unsigned int num_devices;
>> +unsigned int num_devices;
>> +
>> +static void zram_stat_inc(u32 *v)
>> +{
>> +       *v = *v + 1;
>> +}
>> +
>> +static void zram_stat_dec(u32 *v)
>> +{
>> +       *v = *v - 1;
>> +}
>> +
>> +static void zram_stat64_add(struct zram *zram, u64 *v, u64 inc)
>> +{
>> +       spin_lock(&zram->stat64_lock);
>> +       *v = *v + inc;
>> +       spin_unlock(&zram->stat64_lock);
>> +}
>> +
>> +static void zram_stat64_sub(struct zram *zram, u64 *v, u64 dec)
>> +{
>> +       spin_lock(&zram->stat64_lock);
>> +       *v = *v - dec;
>> +       spin_unlock(&zram->stat64_lock);
>> +}
>> +
>> +static void zram_stat64_inc(struct zram *zram, u64 *v)
>> +{
>> +       zram_stat64_add(zram, v, 1);
>> +}
> 
> These could probably use atomic_inc(), atomic64_inc(), and friends, no?
> 

Yes, I think we could use them. Anyways, they are replaced by percpu stats in
patch 3, so probably this can be left as-is.

Thanks,
Nitin
