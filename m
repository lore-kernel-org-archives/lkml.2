Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab0HXAqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:46:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50293 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab0HXAqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:46:01 -0400
Message-ID: <4C731771.1060904@cn.fujitsu.com>
Date: Tue, 24 Aug 2010 08:50:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] btrfs: update stats when allocating from a cluster
References: <4C71CD4B.10606@cn.fujitsu.com> <4C71CD91.4050703@cn.fujitsu.com> <20100823130932.GD2404@localhost.localdomain>
In-Reply-To: <20100823130932.GD2404@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  	spin_unlock(&cluster->lock);
>>  
>> +	if (!ret)
>> +		return 0;
>> +
>> +	spin_lock(&block_group->tree_lock);
>> +
>> +	block_group->free_space -= bytes;
>> +	if (entry->bytes == 0) {
>> +		block_group->free_extents--;
>> +		kfree(entry);
>> +	}
>> +
>> +	spin_unlock(&block_group->tree_lock);
>> +
> 
> Move this part up so we don't drop the spinlock and then re-grab it.  Thanks,
> 

But they are 2 different locks. ;)

And we can't grab block_group->tree_lock when holding cluster->lock.
