Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab0KIRY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:24:59 -0500
Received: from smtp-out.google.com ([74.125.121.35]:33877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab0KIRY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=owgqS7cssHDL6JMeQzaOghY6lvs0QW1LAgiuj3dOymHm27IcR5BdzdNjMyMIVsXQ7b
         jEk+NfELXo0K95rzYEDw==
MIME-Version: 1.0
In-Reply-To: <20101109142053.GA3067@kroah.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
 <20101109033024.GA5220@cr0.nay.redhat.com> <20101109042732.GC5220@cr0.nay.redhat.com>
 <AANLkTingq8R8bc-4fwhBQomdhTgff+fN_vE-pc5zofKX@mail.gmail.com>
 <20101109090645.GG5220@cr0.nay.redhat.com> <20101109142053.GA3067@kroah.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 9 Nov 2010 09:24:33 -0800
Message-ID: <AANLkTi=tUSMrCqnY3-868ugi=b2K78Z=SD=ZDJ36vBUJ@mail.gmail.com>
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
To: Greg KH <greg@kroah.com>
Cc: "Am??rico Wang" <xiyou.wangcong@gmail.com>, simon.kagstrom@netinsight.net,
        davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:20 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Nov 09, 2010 at 05:06:45PM +0800, Am??rico Wang wrote:
>> On Tue, Nov 09, 2010 at 12:34:24AM -0800, Mike Waychison wrote:
>> >On Mon, Nov 8, 2010 at 8:27 PM, Am??rico Wang <xiyou.wangcong@gmail.com> wrote:
>> >> On Tue, Nov 09, 2010 at 11:30:24AM +0800, Am??rico Wang wrote:
>> >>>
>> >> ....
>> >>>
>> >>>So, either we need to de-modulize configfs or replace configfs API
>> >>>with sysfs API. Personally, I prefer the former one, I don't think
>> >>>configfs should be a module as long as it can provide API's
>> >>>for other subsystems, like debugfs.
>> >>>
>> >>
>> >> To clarify, I meant "as long as the API it provides can be used by
>> >> other core subsystems".
>> >>
>> >
>> >Ya, I see the problem with it being a tristate.
>> >
>> >Why not just make netconsole support being compiled in force configfs
>> >to be compiled in?  Or does that just set bad precedent?
>>
>> That is what netconsole does now, and this is fine, since netconsole is
>> a module too, however, after you move that code into netpoll, then netpoll
>> will have a dependence on it, we will have problems.
>>
>> I think we can let NETPOLL_TARGET depend on CONFIGFS_FS=y, but I still
>> see no reason why CONFIGFS_FS should be a module.
>
> No, just have the NETPOLL_TARGET set CONFIG_FS to y, don't force the
> code to always be that way if the user isn't going to want that option.

Can you clarify what you mean by "that way" here?

Presumably, only NETPOLL_TARGET_DYNAMIC needs CONFIGFS_FS=y ?

Maybe none of this matters:  NETPOLL_TARGET itself *can* be a module,
as it doesn't do anything more than stack a target management layer on
top of the existing netpoll code.  Nothing in this patchset actually
changes anything within netpoll itself.

Mike Waychison
