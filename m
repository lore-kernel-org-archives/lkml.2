Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab0KDJ5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 05:57:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47929 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab0KDJ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 05:57:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jEctS8cFt1jo5taxsJ+PfAuv2Kba0cl+6PAzoscivvoYLv1+3KiqaCnbaD3iD88x3s
         +/pfbLVUt2q0vurz0kTVxhjEBuL5h7S80sW9DUhbdOgarSjoOYc20QEQo1EwOwXBvZZC
         0YGJQ7kmSjlBtmJ/h8HribF2PTCWuipth3yA0=
Message-ID: <4CD2836E.4090908@gmail.com>
Date: Thu, 04 Nov 2010 10:57:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Dr. Werner Fink" <werner@suse.de>,
        Al Viro <viro@ZenIV.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] console: add /proc/consoles
References: <1288798509-23550-1-git-send-email-jslaby@suse.cz> <20101103161342.GA4942@suse.de> <4CD18ACB.4060108@suse.cz> <20101103162251.GA5404@suse.de> <4CD18CFC.7080100@suse.cz> <20101103173944.GA6589@suse.de> <4CD1C01E.1010309@gmail.com> <20101103211237.GA2105@suse.de>
In-Reply-To: <20101103211237.GA2105@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 10:12 PM, Greg KH wrote:
> On Wed, Nov 03, 2010 at 09:03:42PM +0100, Jiri Slaby wrote:
>> On 11/03/2010 06:39 PM, Greg KH wrote:
>>> On Wed, Nov 03, 2010 at 05:25:32PM +0100, Jiri Slaby wrote:
>>>> Actually where this code should be in fs/proc/? Most of the /proc/* is
>>>> handled elsewhere (fs/ mm/ kernel/). The rest is handled in specialized
>>>> fs/proc/FILE.c.
>>>
>>> What's wrong with putting it into fs/proc/proc_tty.c?  That seems like
>>> the most logical thing to me...
>>
>> consoles have little to do with ttys. Except ttys can be consoles.
> 
> And all consoles are ttys :)

Oh, they are not. Or maybe I'm missing something?

>> To me
>> it seems illogical to have info about netconsole, parallel consoles or
>> early serials somewhere in /proc/tty/. That's why I moved the info from
>> /proc/tty/ to /proc and the code from fs/proc/proc_tty.c to
>> kernel/printk.c where consoles are managed.
> 
> Ok, how about fs/proc/proc_console.c instead?

Yes, this sounds good.

> And no, printk.c is not the most logical place for something like this.
> If I see a proc file, I am not going to automatically assume that
> printk.c would have anything to do with it.  As it really doesn't
> (printk goes to the kernel log buffer, not a console).

Actually it does all the job:
* filling the log/ring buffer (v/printk)
* managing consoles (un/register_console)
* writing to consoles (call_console_drivers and friends)

thanks,
-- 
js
