Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab0GHRrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:47:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49314 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab0GHRrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:47:51 -0400
Message-ID: <4C360F08.9060304@ru.mvista.com>
Date: Thu, 08 Jul 2010 21:46:48 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Sergei Shtylyov <sshtylyov@mvista.com>,
       Patrick Pannuto <ppannuto@codeaurora.org>,
       dbrownell@users.sourceforge.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, sboyd@codeaurora.org
Subject: Re: [PATCH] usb: gadget: #include device.h in gadget.h
References: <4C35200C.2040209@codeaurora.org> <20100708033420.GA24135@suse.de> <4C35945F.9050502@ru.mvista.com> <20100708151345.GB12452@suse.de>
In-Reply-To: <20100708151345.GB12452@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

>>>> gadget.h uses structures defined in device.h, it must include it. In
>>>> most cases, gadget.h is preceded by linux/platform_device.h, but if
>>>> you are grouping headers sanely, device.h may not be pulled in until
>>>> *after* gadget (e.g. mach/msm_device.h), thus gadget.h should not
>>>> rely on something else #including device.h

>>    As well as a number of other headers.

    Totally six, to be precise.

>> I have postaed a patch
>> addressing the missing #include's already.

> Yes I know,

    That was mostly for Patrick.

> and my same statment stands.

    :-/

>>>> include/linux/usb/gadget.h:488: error: field 'dev' has incomplete type
>>> Why not just provide an "empty" prototype for whatever is needed.

>>    Empty prototype of what, 'struct device'? Have you looked at the code at all?

> Nope, I try not to :)

    Right, that file has been "stained" by one #include already (which seems 
to be useless though).

>> 	struct device			dev;

> Ok, that wouldn't work.

    Then let's just leave it as it is. :-)

>>> How about just fixing up the .c file that the problem happens in, to
>>> include device.h first?  Is this an issue in the current tree somehow?

>>    In my opinion, this is just insane approach.

> Sorry, but that seems to go against what the rest of the kernel is
> doing.

    Thus far, I've seen headers satisfying their own dependencies, and people 
accepting patches to add missing #include's to headers. This list was the 
first place where I've learned that the problems should be addressed not where 
they exist but left to be dealt with at every place where a defective header 
is used (and the time wasted on that). I haven't heard any convincing 
arguments for this cause so far...

> thanks,
> greg k-h

WBR, Sergei
