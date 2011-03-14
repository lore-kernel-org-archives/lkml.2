Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab1CNWsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:48:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40650 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab1CNWsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:48:11 -0400
Message-ID: <4D7E9AD5.1080902@zytor.com>
Date: Mon, 14 Mar 2011 15:46:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: "H. Peter Anvin" <hpa@kernel.org>, Greg KH <greg@kroah.com>,
        Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 12/12] driver: Google Memory Console
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com> <20110312014358.6133.34911.stgit@mike.mtv.corp.google.com> <4D7D9F92.5010604@kernel.org> <AANLkTino-QB=2ctS4QFWQAr3gXTc5GfC5q5bQcFguVNs@mail.gmail.com>
In-Reply-To: <AANLkTino-QB=2ctS4QFWQAr3gXTc5GfC5q5bQcFguVNs@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 01:03 PM, Mike Waychison wrote:
> On Sun, Mar 13, 2011 at 9:54 PM, H. Peter Anvin <hpa@kernel.org> wrote:
>> On 03/11/2011 05:43 PM, Mike Waychison wrote:
>>> This patch introduces the 'memconsole' driver.
>>>
>>> Our firmware gives us access to an in-memory log of the firmware's
>>> output.   This gives us visibility in a data-center of headless machines
>>> as to what the firmware is doing.
>>>
>>> The memory console is found by the driver by finding a header block in
>>> the EBDA.  The buffer is then copied out, and is exported to userland in
>>> the file /sys/firmware/log.
>>>
>>
>> OK, I really don't like this.
>>
>> All it has is a 32-bit nonrandom signature, no DMI keying or anything
>> else to protect it.  This really isn't sufficient.
> 
> Good point.  I'll add some DMI strings checks.  It *should* be
> sufficient to just ensure that "Google, Inc." is the board vendor
> string (though I'll need to run some tests to verify that this covers
> the boards we care about).
> 

Sounds good.

	-hpa

