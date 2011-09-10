Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1IJAS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:18:59 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:60519 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab1IJAS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:18:58 -0400
Message-ID: <4E6AACF0.2080907@vflare.org>
Date: Fri, 09 Sep 2011 20:18:56 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] zram: Set initial disksize to some default value
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org> <1315609264-13632-6-git-send-email-ngupta@vflare.org> <20110909231209.GB24604@kroah.com>
In-Reply-To: <20110909231209.GB24604@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 07:12 PM, Greg KH wrote:

> On Fri, Sep 09, 2011 at 07:01:04PM -0400, Nitin Gupta wrote:
>> Currently, we set initial disksize as 0, which forces
>> user to write some value to corresponding zram device's
>> sysfs node, before the device can be used. Now, we avoid
>> this step by providing some default size initially.
>>
>> To change the disksize, user must:
>>  - Reset disk.
>> 	Ex: echo 1 > /sys/block/zram0/reset
>> (NOTE: disksize is set to the default value after reset)
>>
>>  - Set new disksize.
>> 	Ex: echo $((256*1024*1024)) > /sys/block/zram0/disksize
> 
> So, what tools just broke with this change?
> 
> And where is the sysfs file documentation change that should go along
> with this?
> 


This change does not change any sysfs names or behavior, so does not
break any scripts that assume the current behavior. I also verified that
sysfs documentation (ABI/testing/sysfs-block-zram) need not be changed
and same with drivers/staging/zram/zram.txt.

PS: zram_set_disksize() change (patch 1/5) also does not break any
documentation.

Thanks,
Nitin




