Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab1IJCEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 22:04:50 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:62198 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab1IJCEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 22:04:50 -0400
Message-ID: <4E6AC5B2.40703@vflare.org>
Date: Fri, 09 Sep 2011 22:04:34 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Greg KH <greg@kroah.com>, Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] zram: Set initial disksize to some default value
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org> <1315609264-13632-6-git-send-email-ngupta@vflare.org> <20110909231209.GB24604@kroah.com>            <4E6AACF0.2080907@vflare.org> <62714.1315615809@turing-police.cc.vt.edu>
In-Reply-To: <62714.1315615809@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 08:50 PM, Valdis.Kletnieks@vt.edu wrote:

> On Fri, 09 Sep 2011 20:18:56 EDT, Nitin Gupta said:
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
>> break any scripts that assume the current behavior.
> 
> Consider the current case:   We init size to zero, and a startup script changes
> it to 1024 and then sticks 768 of data in there.  No Problem.
> 
> We now get a kernel that's built with a default of 512.  The startup script
> tries to change it to 1024, but doesn't know it has to splat something into
> 'reset' for it to actually work.  It then tries to stick 768 of data in there,
> and hilarity ensues...
> 
> If I haven't misunderstood...
> 


Setting default size of say 512 doesn't make the device initialized.
The initialization happens only when user issues any I/O to the device
and only after initialization the disksize cannot be changed.
So, when user writes say 768 as new disksize in uninitialized state, the
new disksize will take effect and there will be no surprises.

Device reset is needed only when user wants to discard existing data and
bring device to uninitialized state again, after which disksize can be
changed again.

Nitin

