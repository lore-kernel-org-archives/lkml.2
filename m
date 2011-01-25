Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1AYVnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:43:19 -0500
Received: from smtp-out.google.com ([74.125.121.67]:37135 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1AYVnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j1uQcIUZoX2orfA4/zSAIeehbBxv0QfbijCst4p8bhqV06hftQODEsuF6u6/9lzFgO
         /xkasbQrarY2aouFkuDw==
MIME-Version: 1.0
In-Reply-To: <4D3F4275.50709@garzik.org>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
	<20110125002439.12637.8515.stgit@mike.mtv.corp.google.com>
	<20110125020658.GA3481@kroah.com>
	<AANLkTinLoDN_6zG56J7V154jrRc-K+BzAHFO3qS_r8J0@mail.gmail.com>
	<4D3F4275.50709@garzik.org>
Date: Tue, 25 Jan 2011 13:43:14 -0800
Message-ID: <AANLkTim4fG0-F0+E-DHa4=XGdk1rFbRA68nvt9bfURiK@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] Add oops notification chain.
From: Aaron Durbin <adurbin@google.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mike Waychison <mikew@google.com>, Greg KH <greg@kroah.com>,
        torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 1:36 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 01/25/2011 03:01 PM, Mike Waychison wrote:
>>
>> On Mon, Jan 24, 2011 at 6:06 PM, Greg KH<greg@kroah.com>  wrote:
>>>
>>> On Mon, Jan 24, 2011 at 04:24:39PM -0800, Mike Waychison wrote:
>>>>
>>>> From: Aaron Durbin<adurbin@google.com>
>>>>
>>>> Later firmware patches in this series would like to be able to be
>>>> notified whenever an oops occurs on the system, so that it can be
>>>> recorded in the boot log.
>>>>
>>>> This patch introduces a notifier_block called "oops_notifier_list"
>>>> so that drivers can register to get called whenever an Oops is
>>>> triggered.
>>>
>>> But we already have a panic notifier list.  Why create a new one?
>>> What's wrong with the existing one that doesn't work properly for you?
>>
>> AFAICT, the panic notifier list doesn't get called on oops.
>
> Have you tried playing with panic_on_oops ?

Yes. We actually run in that setup. However, oops != panic. They are 2
distinct events. Sometimes we panic without the oops under certain
situations. That is why it is desirable to have 2 distinct events.
>
>        Jeff
>
>
>
