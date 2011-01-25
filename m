Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1AYVyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:54:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63461 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1AYVyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:54:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=prOVnzceQ4JTkt9VPqvKR1Dsgpea2x7KN8HC6nZ9t0XkjZOnzFU+Nz7TV+FnUZzOE3
         xK2Skxdak9uClfDTr8Em+sBs/OCdnYvVoPpTzI/ZcOvDbsqeFkuklxlSW7NyM8kqMrbH
         Aq5G6QbsZKjXNcepNWK4XWJNEpN4rztVteuGI=
Message-ID: <4D3F4699.60809@garzik.org>
Date: Tue, 25 Jan 2011 16:54:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Aaron Durbin <adurbin@google.com>
CC: Mike Waychison <mikew@google.com>, Greg KH <greg@kroah.com>,
        torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 1/6] Add oops notification chain.
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com> <20110125002439.12637.8515.stgit@mike.mtv.corp.google.com> <20110125020658.GA3481@kroah.com> <AANLkTinLoDN_6zG56J7V154jrRc-K+BzAHFO3qS_r8J0@mail.gmail.com> <4D3F4275.50709@garzik.org> <AANLkTim4fG0-F0+E-DHa4=XGdk1rFbRA68nvt9bfURiK@mail.gmail.com>
In-Reply-To: <AANLkTim4fG0-F0+E-DHa4=XGdk1rFbRA68nvt9bfURiK@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 04:43 PM, Aaron Durbin wrote:
> On Tue, Jan 25, 2011 at 1:36 PM, Jeff Garzik<jeff@garzik.org>  wrote:
>> On 01/25/2011 03:01 PM, Mike Waychison wrote:
>>>
>>> On Mon, Jan 24, 2011 at 6:06 PM, Greg KH<greg@kroah.com>    wrote:
>>>>
>>>> On Mon, Jan 24, 2011 at 04:24:39PM -0800, Mike Waychison wrote:
>>>>>
>>>>> From: Aaron Durbin<adurbin@google.com>
>>>>>
>>>>> Later firmware patches in this series would like to be able to be
>>>>> notified whenever an oops occurs on the system, so that it can be
>>>>> recorded in the boot log.
>>>>>
>>>>> This patch introduces a notifier_block called "oops_notifier_list"
>>>>> so that drivers can register to get called whenever an Oops is
>>>>> triggered.
>>>>
>>>> But we already have a panic notifier list.  Why create a new one?
>>>> What's wrong with the existing one that doesn't work properly for you?
>>>
>>> AFAICT, the panic notifier list doesn't get called on oops.
>>
>> Have you tried playing with panic_on_oops ?
>
> Yes. We actually run in that setup. However, oops != panic. They are 2
> distinct events. Sometimes we panic without the oops under certain
> situations. That is why it is desirable to have 2 distinct events.

That's a circular statement:  They are distinct events, so it is 
desirable that they be distinct events?

Set a flag, a la oops_in_progress (unfortunately name, as it's called 
during a panic too).  Call it...  oops_really_in_progress.  Then will 
the panic notifier list suffice?

	Jeff



