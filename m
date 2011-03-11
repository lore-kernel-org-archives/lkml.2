Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab1CKXkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 18:40:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38149 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab1CKXkA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 18:40:00 -0500
MIME-Version: 1.0
In-Reply-To: <4D7AA674.2050705@linaro.org>
References: <4D79F068.2080009@linaro.org> <AANLkTi=+6cp=F1ZDiH1vFwqvseU-Punwpq99P1j-U4Q1@mail.gmail.com>
 <4D7AA674.2050705@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 11 Mar 2011 16:39:39 -0700
X-Google-Sender-Auth: pvwqnk_9WhFDn1HcCahHbIZLQO8
Message-ID: <AANLkTimwUUBNtQ7qG5NXCOs+fODZHypNesA9mooseW9+@mail.gmail.com>
Subject: Re: RFC: Platform data for onboard USB assets
To: andy.green@linaro.org
Cc: Andy Green <andy@warmcat.com>, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 3:47 PM, Andy Green <andy@warmcat.com> wrote:
> On 03/11/2011 10:45 PM, Somebody in the thread at some point said:
>>
>> On Fri, Mar 11, 2011 at 2:50 AM, Andy Green<andy@warmcat.com>  wrote:
>>>
>>> Hi -
>>>
>>> platform_data is a well established way in Linux to pass configuration
>>> data
>>> up to on-board assets from a machine file like mach-xyz.c.  It's also
>>> supported to pass platform_data up to devices that are probed
>>> asynchronously
>>> from busses like i2c as well, which is very handy.
>>>
>>> However AFAIK it's not possible to bind platform_data to probed USB
>>> devices
>>> as it stands.
>>
>> Oh, please no.
>>
>> platform_data is an ugly non-type-checked anonymous pointer.  If you
>> need to pass data to a driver, use something better designed.  A
>> device tree fragment would work, or provide some kind of query api.
>> platform_data is definitely the wrong approach.
>
> $ grep platform_data drivers/* -R | wc -l
> 2110

I'm not disputing that it is widely used; and it does make a certain
amount of sense for static device registrations, but it is not a nice
interface, and it is a horrible idea for dynamic devices.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
