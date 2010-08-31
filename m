Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0HaSP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 14:15:26 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57171 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0HaSPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BWI7zU4wSTh9vTRO6jJIuXavdmWDrJytnjPraJW1jiElBX3iCbKIu5eA+JKUekzxvJ
         135AJZiMgblg4CYLwm2hQ1qmX2v8rqxx1Bvfx6Uz8ChzsnPfCI5Ur1K7cpvVlmfrEtcJ
         UWqPd94uKvrfSIE/uhZUvRUieaPk0qtxjc7hk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan>
	<AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com>
	<alpine.DEB.2.00.1008271306100.24692@p34.internal.lan>
	<alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
	<alpine.DEB.2.00.1008310717260.4858@p34.internal.lan>
	<alpine.DEB.2.00.1008310732120.5156@p34.internal.lan>
	<alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
Date: Tue, 31 Aug 2010 11:15:23 -0700
Message-ID: <AANLkTi=s5LusUgDFY4+qeWg4nfXZzF34UEafqZwEG+AM@mail.gmail.com>
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
From: adam radford <aradford@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin,

There were no changes in the driver other than to force a 60 second I/O
timeout.  You probably have a udev rule that was already giving you 60
second timeouts for all scsi devices, so this patch did absolutely nothing.

More likely is that there is an I/O pattern change between the kernels
that is causing a 3ware firmware issue (or drive firmware issue) on
your configuration.
I have forwarded your case to 3ware firmware support.

-Adam


On Tue, Aug 31, 2010 at 5:23 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Tue, 31 Aug 2010, Justin Piszcz wrote:
>
>>
>>
>> On Tue, 31 Aug 2010, Justin Piszcz wrote:
>>
>>>
>>>
>>> On Sun, 29 Aug 2010, Justin Piszcz wrote:
>>>
>>>> On Fri, 27 Aug 2010, Justin Piszcz wrote:
>>
>> Per my earlier message, both cards were resetting, scsi0 and scsi1 under
>> kernel 2.6.35(.x), with 2.6.34, the lag problem is gone and my machine is
>> back to normal again.  It is unlikely that both cards would be at fault,
>> in addition I spent several hours trying different things, removing the
>> BBU
>> modules for example, but always staying on the 2.6.35 kernel.
>>
>> I am now able to run rss2email (which ALWAYS caused the machine to lockup
>> and freeze until one of the controllers reset) without any problems using
>> 2.6.34.
>>
>> 2.6.34.1 = good
>> 2.6.35.x = has 3ware bug
>>
>> There appears to be a bug in the commit for the 3w-9xxx updates.
>>
>> On 2.6.34 now and no problems so far, I am continuing to test.
>>
>> http://marc.info/?l=linux-kernel&m=127419418304483&w=2
>>
>> Adam Radford (2):
>>     3ware maintainers update
>>     3w-xxxx, 3w-9xxx: force 60 second timeout
>>
>>
>> Justin.
>
>
> Latest-- 2.6.34.x seems to fix the issue, no lag whatsoever, the system is
> very responsive when running rss2email, again no lag, have run 10-15 tests
> without a single incident.  I also re-enabled msi and put my optimization
> script back in init.d, everything continues to work perfectly.
>
> Will wait for Adam on what went wrong with the 2.6.35 3w-9xxx update.
>
> Justin.
>
>
