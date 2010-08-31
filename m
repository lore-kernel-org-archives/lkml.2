Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0HaGJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:09:40 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37998 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0HaGJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:09:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KDqUxPwpO8Gs0f3msfE5vrfZxhizZG6Ys5NWCmYvr6XU9C/3fDAsCibqIpM/uSIEz2
         9i4REfC5Xb35PM0RzMFw==
MIME-Version: 1.0
In-Reply-To: <20100828235029.GA7071@localhost>
References: <1282963227-31867-1-git-send-email-mrubin@google.com>
 <1282963227-31867-4-git-send-email-mrubin@google.com> <20100828235029.GA7071@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 30 Aug 2010 23:09:14 -0700
Message-ID: <AANLkTi=KjbfqzZsD6MOQG+4i7vHj6ZEh1_nF7DpwqeLV@mail.gmail.com>
Subject: Re: [PATCH 3/4] writeback: nr_dirtied and nr_cleaned in /proc/vmstat
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 4:50 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> It's silly to have the different names nr_dirtied and pages_cleaned
> for the same item.

I agree. Will fix.

> The output format is quite different from /proc/vmstat.
> Do we really need to "Node X", ":" and "times" decorations?

Node X is based on the meminfo file but I agree it's redundant information.

> And the "_PAGES" in NR_FILE_PAGES_DIRTIED looks redundant to
> the "_page" in node_page_state(). It's a bit long to be a pleasant
> name. NR_FILE_DIRTIED/NR_CLEANED looks nicer.

Yeah. Will fix.


>> +static SYSDEV_ATTR(vmstat, S_IRUGO, node_read_vmstat, NULL);
>> +
>>  static ssize_t node_read_distance(struct sys_device * dev,
>>                       struct sysdev_attribute *attr, char * buf)
>>  {
>> @@ -243,6 +255,7 @@ int register_node(struct node *node, int num, struct node *parent)
>>               sysdev_create_file(&node->sysdev, &attr_meminfo);
>>               sysdev_create_file(&node->sysdev, &attr_numastat);
>>               sysdev_create_file(&node->sysdev, &attr_distance);
>> +             sysdev_create_file(&node->sysdev, &attr_vmstat);
>>
>>               scan_unevictable_register_node(node);
>>
>> @@ -267,6 +280,7 @@ void unregister_node(struct node *node)
>>       sysdev_remove_file(&node->sysdev, &attr_meminfo);
>>       sysdev_remove_file(&node->sysdev, &attr_numastat);
>>       sysdev_remove_file(&node->sysdev, &attr_distance);
>> +     sysdev_remove_file(&node->sysdev, &attr_vmstat);
>>
>>       scan_unevictable_unregister_node(node);
>>       hugetlb_unregister_node(node);          /* no-op, if memoryless node */
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 6e6e626..d42f179 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -104,6 +104,8 @@ enum zone_stat_item {
>>       NR_ISOLATED_ANON,       /* Temporary isolated pages from anon lru */
>>       NR_ISOLATED_FILE,       /* Temporary isolated pages from file lru */
>>       NR_SHMEM,               /* shmem pages (included tmpfs/GEM pages) */
>> +     NR_FILE_PAGES_DIRTIED,  /* number of times pages get dirtied */
>> +     NR_PAGES_CLEANED,       /* number of times pages enter writeback */
>
> How about the comments /* accumulated number of pages ... */?

OK.
May not get patch out today but will incorporate these fixes. Thank you again.

mrubin
