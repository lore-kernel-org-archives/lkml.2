Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1LLRqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:46:37 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50987 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1LLRqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:46:33 -0500
MIME-Version: 1.0
In-Reply-To: <20111212173344.GA10162@kroah.com>
References: <1323693892-11570-1-git-send-email-dbaluta@ixiacom.com>
	<20111212150255.GA7506@kroah.com>
	<CAEnQRZBiVDAHH+uZ=Ugk=UP5qSvvMViGTM-bRWr+E27zivOUug@mail.gmail.com>
	<1323703934.1765.15.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAEnQRZCZdPw9eWVmdvhtF7KCQkYpLMrkhv5qd5xYckxWksN+0w@mail.gmail.com>
	<1323704494.1765.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAEnQRZAt0X6cxGLgLUVTB9rzLKVYLEnh=azS9WOyKAkUZEpj4g@mail.gmail.com>
	<20111212173344.GA10162@kroah.com>
Date: Mon, 12 Dec 2011 19:46:33 +0200
X-Google-Sender-Auth: 4wGiClHoWbx6IAi4UYjFCyPhk_o
Message-ID: <CAEnQRZDFvD3BTJs45hvP8LVCF_SNrYZyxxiiGXXP+koFfaYAdQ@mail.gmail.com>
Subject: Re: [PATCH] kref: add function for reading kref value
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Greg KH <greg@kroah.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, adobriyan@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 7:33 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Dec 12, 2011 at 06:42:59PM +0200, Daniel Baluta wrote:
>> On Mon, Dec 12, 2011 at 5:41 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> > Le lundi 12 décembre 2011 ŕ 17:39 +0200, Daniel Baluta a écrit :
>> >
>> >> Ok, for the moment it seems to be a bad idea. But my intention is
>> >> to integrate kref to networking code, and then to write a general
>> >> debugging tool for refs.
>> >>
>> >> Tracking down reference count problems is hard, and this tool can
>> >> really help everyone.
>> >
>> > I dont think kref will help you that much, because its used everywhere.
>> >
>> > Adding a general debugging tool will provide too much noise.
>> >
>> > Instead, we (network dev) add debugging points where we want.
>>
>> Yes, but you have to do this each time you start debugging, for a
>> particular referenced counted object.
>>
>> We must find a clever solution to avoid the noise. (e.g use
>> /proc, /sysfs, /debugfs options to trigger dumping info for
>> some/all objects with a certain state).
>
> Then use the dynamic debug infrastructure, which is there to help you
> try to handle this type of debugging on-the-fly.
>
> But again, it's not a kref issue, sorry.

I see. Thanks.

One last remark: Should we encourage people
to use kref implementation, instead of making
their own ?

What are the chances of accepting changes with
respect to this?

Just a few examples:

neighbour.h
295:#define neigh_hold(n)	atomic_inc(&(n)->refcnt)

addrconf.h
219:static inline void in6_dev_hold(struct inet6_dev *idev)

Daniel.
