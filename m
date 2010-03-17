Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0CQOq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:46:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:60485 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab0CQOqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:46:54 -0400
Message-ID: <4BA0EB57.30405@windriver.com>
Date: Wed, 17 Mar 2010 09:46:47 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] V2 usb console improvements series
References: <Pine.LNX.4.44L0.1003171027501.1734-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003171027501.1734-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2010 14:46:48.0118 (UTC) FILETIME=[ABEBBD60:01CAC5E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 09:30 AM, Alan Stern wrote:
> On Tue, 16 Mar 2010, Jason Wessel wrote:
>
>   
>> Part of having the console stable requires that usb sysrq handler get
>> executed in a tasklet.  The hcd device lock is always held while the
>> driver call backs are executed.  The means you cannot get the sysrq
>> printk's out to the usb console device after the in_flight urb queue
>> is filled.
>>     
>
> Either I don't understand this comment properly or else it is simply
> wrong.  HCDs do not continue to hold their locks when handing completed
> URBs back to drivers.  The giveback call occurs with interrupts
> disabled, but no locks are held.
>
>   

The call back from the urb processing holds a lock.  The sysrq is
invoked from that context, which will do a whole lot of printk()
(sysrq-t for example).   The problem is that writes will queue for a bit
and then cannot get drained because the hcd lock is not available. 
Using a tasklet seemed like the obvious choice to move the sysrq
processing to a context where the hcd lock is not likely to be in use.

> Does this mean one of the patches in your series can be simplified?
>   

I will further simplify if you have some recommendations.

Thanks,
Jason.
