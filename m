Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab1CaPl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:41:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38471 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab1CaPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=RVVLZSYwgRW887fBCRqlY8K5zc/ZjJgYRYPfoUQtiLaF4fYC0/zphteOGoTluqZndb
         NmaahEJOstbgAro9XFm/oPvtoyXLgnvvcnO9TsKimkk6e7niPltygOtaHlHJhq/cE8an
         I1CV9hpF9mwVdJaOgTBoQuBH1cMW+rdbz4HEs=
Message-ID: <4D94A0C1.1060608@gmail.com>
Date: Thu, 31 Mar 2011 08:41:53 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110316 Thunderbird/3.1.9
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Manjunatha Halli <manjunatha_halli@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [BUG] NULL pointer dereference in dev_get_drvdata
References: <1301448497.14261.319.camel@gandalf.stny.rr.com>	<4D93508D.30701@gmail.com> <20110331111659.0c77abbe@schatten.dmk.lab>
In-Reply-To: <20110331111659.0c77abbe@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 02:16 AM, Florian Mickler wrote:
> On Wed, 30 Mar 2011 08:47:25 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>
>>
>> strange thing with this, is one instance my screen went black, then
>> something similar showed up on screen but then the screen kind of went
>> back to normal(was able to move the mouse, but most of everything was
>> frozen), another instance was shutting down the system pics are here:
>>
>> http://www.flickr.com/photos/44066293@N08/5573957179/
>> http://www.flickr.com/photos/44066293@N08/5574543648/
>> (not the best camara used)
>>
>> this does not fire off all the time, but it does.
>> (I will keep my eye out with this one).
>>
>> Justin P. Mattock
>>
>
> even with that resolution (240x320, that's a joke, right? do I need to
> login or something like that?) I see that your stacktrace is
> different.

yeah... the iphone is only capable of so good of a picture.

>
> The stacktrace is the cascade of function-calls that lead to the
> execution of the current code. A null-pointer in the driver-core
> normally means that someone on the calling site did something wrong.
> So in order to fix the bug, you have to look at the stack trace and
> check how that null pointer got handed down to that function.
>

this was(I think) similar but not the same as dev_get_drvdata
(all I know is this has fired off from time to time).

> If you have 2 drivers. Both seperately calling the same function with a
> nullpointer you have 2 seperate issues that trigger the same thing
> (null pointer exception) in the same function. so it is not sufficient
> to look at where the bug happened, you also need to check what is the
> cause.
>
> Regards,
> Flo
>
two drivers calling the same function(sounds bad!) this would be a race 
condition right?

As for this message I will keep my eye out for anything in this area and 
report it to you guys.

Justin P. Mattock
