Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab1IJOvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 10:51:53 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:35761 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab1IJOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 10:51:52 -0400
Message-ID: <4E6B7985.5080709@vflare.org>
Date: Sat, 10 Sep 2011 10:51:49 -0400
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
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org> <1315609264-13632-6-git-send-email-ngupta@vflare.org> <20110909231209.GB24604@kroah.com> <4E6AACF0.2080907@vflare.org> <20110910004238.GB27110@kroah.com>
In-Reply-To: <20110910004238.GB27110@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 08:42 PM, Greg KH wrote:

> On Fri, Sep 09, 2011 at 08:18:56PM -0400, Nitin Gupta wrote:
>> On 09/09/2011 07:12 PM, Greg KH wrote:
>>
>>> On Fri, Sep 09, 2011 at 07:01:04PM -0400, Nitin Gupta wrote:
>>>> Currently, we set initial disksize as 0, which forces
>>>> user to write some value to corresponding zram device's
>>>> sysfs node, before the device can be used. Now, we avoid
>>>> this step by providing some default size initially.
>>>>
>>>> To change the disksize, user must:
>>>>  - Reset disk.
>>>> 	Ex: echo 1 > /sys/block/zram0/reset
>>>> (NOTE: disksize is set to the default value after reset)
>>>>
>>>>  - Set new disksize.
>>>> 	Ex: echo $((256*1024*1024)) > /sys/block/zram0/disksize
>>>
>>> So, what tools just broke with this change?
>>>
>>> And where is the sysfs file documentation change that should go along
>>> with this?
>>>
>>
>>
>> This change does not change any sysfs names or behavior, so does not
>> break any scripts that assume the current behavior. I also verified that
>> sysfs documentation (ABI/testing/sysfs-block-zram) need not be changed
>> and same with drivers/staging/zram/zram.txt.
> 
> Huh, you just said the behavior changed as described in your comment
> above.  You said the user no longer has to do a step to accomplish
> something.  What happens if they do do that after this patch?
> 


The current documentation states that:

  "" (from drivers/staging/zram/zram.txt)
2) Set Disksize (Optional):
        Set disk size by writing the value to sysfs node 'disksize'
        (in bytes). If disksize is not given, default value of 25%
        of RAM is used.
  ""

So existing code did not correctly implement this behavior -- user had
to set a disksize for zram to be usable. With this patch, the code now
behaves exactly as described in documentation. So, we now avoid the
extra step of setting a disksize as documented.  The user can still, of
course, set another disk value if needed.

So, in summary, no documentation changes are required with this change.
I will also add this explanation in changelog when submitting v4 patches.

Thanks,
Nitin
