Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab2HQPbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:31:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932180Ab2HQPbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:31:09 -0400
Message-ID: <502E63F0.8050406@redhat.com>
Date: Fri, 17 Aug 2012 17:32:00 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Miklos Szeredi <miklos@szeredi.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [REGRESION] Suspend hangs with 3.6-rc1 on Lenovo T60 notebook
References: <Pine.LNX.4.44L0.1208171025330.25520-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208171025330.25520-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/17/2012 04:27 PM, Alan Stern wrote:
> On Fri, 17 Aug 2012, Alan Stern wrote:
>
>> On Fri, 17 Aug 2012, Hans de Goede wrote:
>>
>>> No my patch was a hack to undo the results of the commit causing
>>> the regression in the IDE case. But Alan's approach clearly is
>>> much better! Once we are sure drvdata is not used anywhere the
>>> dev_set_drvdata call could be removed in the place where my
>>> hack added a second call to it. Note that there are likely
>>> actual ide drivers using it, without setting it themselves since
>>> the ide core was setting it. So removing it will require even more
>>> auditing / checking.
>>
>> I did search for dev_get_drvdata() calls in drivers/ide; there were no
>> other calls that retrieved an ide_drive_t value.  But I didn't check
>> anywhere else in the kernel.  In fact, I'm not sure where else to look.
>
> After a little more checking: Among all the .c files in the kernel
> which match the pattern '[^a-z]ide_', the only occurrences of
> dev_get_drvdata() which retrieve an ide_drive_t value are the two in
> ide-pm.c.

Thanks, good work! That means we should move forward with submitting
Miklos' patch to the ide subsystem maintainer asap.

Also if someone feels like it we still could do the 2 follow up / clean
up patches:

1) Removin the set_drvdata call from hwif_register_devices()
    in ide-prove.c
2) Fixup ide-generic.c ide_remove to not dereference a NULL dev->driver

Regards,

Hans
