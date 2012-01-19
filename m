Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab2ASKzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:55:55 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49855 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2ASKzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:55:53 -0500
Message-ID: <4F17F6AF.10604@linux.vnet.ibm.com>
Date: Thu, 19 Jan 2012 16:25:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
References: <201201172345.15010.rjw@sisk.pl> <201201180015.56510.rjw@sisk.pl> <4F16C24A.4050007@linux.vnet.ibm.com> <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com> <4F16F94C.4020000@linux.vnet.ibm.com> <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com> <4F16FF0D.1030606@linux.vnet.ibm.com> <20120118173037.GE30664@google.com> <20120118173348.GF30664@google.com> <20120119103707.GA13308@elf.ucw.cz>
In-Reply-To: <20120119103707.GA13308@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011910-9574-0000-0000-0000010472AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 04:07 PM, Pavel Machek wrote:

> Hi!
> 
>>>> I agree, but I was trying to keep the comment from growing too long ;)
>>>
>>> It doesn't have to be long.  It just has to give some meaning to the
>>> decision.  AFAICS, it is correct to call try_to_freeze() on
>>> unlock_system_sleep() regardless of 20sec window.  There's no
>>> guarantee the unlocking task is gonna hit try_to_freeze() elsewhere
>>> and not calling it actually makes the interface buggy.
>>
>> To give an example,
>>
>> 	/*
>> 	 * XXX: Open code SKIP clearing for now to avoid invoking
>> 	 * try_to_freeze().  This isn't correct but this function is
>> 	 * called from deep inside hibernation path and calling
>> 	 * try_to_freeze() leads to hang during hibernation.  This
>> 	 * will be properly fixed soon.  See commit message for
>> 	 * more details.
>> 	 */
> 
> Which paths are affected?
> 
> With uswsusp, we have userland in control of hibernation process; I'd
> say almost anything can be called...


Hi Pavel,
I am afraid you are looking at a stale comment. We finalized on a
different comment altogether.

Here is the latest patch:
http://thread.gmane.org/gmane.linux.kernel/1240493/focus=1240976

Rafael made some suggestions on this one here
http://thread.gmane.org/gmane.linux.kernel/1240493/focus=1241028

I will address that and send out a patch soon.

Do let me know if you have any comments, thanks!

Regards,
Srivatsa S. Bhat

