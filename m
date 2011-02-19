Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1BSKQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 05:16:19 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:63542 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1BSKQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 05:16:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FM1L6JF+fj6CdpkS+TanzWEA9AMNZ32KgWWNMzV6kv/cVidQGOgFxjTprgdVcjsxj7
         NpQU1huut+WfHBsybPRUwHjjyt+sm6uIsZ5bvfr+Y0hVxwCUuwUw8dcpUIlfB4gK85TO
         m9kUjNdqkIjNrMfZAN6S57zaodQzDNCJSDAjc=
MIME-Version: 1.0
In-Reply-To: <20110219100017.GA29493@n2100.arm.linux.org.uk>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
	<201102181928.05911.rjw@sisk.pl>
	<AANLkTi=j9KeX2TSzMaKMWR6GpXjFcsjp0z8Rt+ArLXiV@mail.gmail.com>
	<201102182120.29977.rjw@sisk.pl>
	<20110218202744.GA19427@n2100.arm.linux.org.uk>
	<AANLkTim2TfG-18XN3r9m3Rq68ZD6QHUY7X82E4-XWH83@mail.gmail.com>
	<20110219100017.GA29493@n2100.arm.linux.org.uk>
Date: Sat, 19 Feb 2011 11:16:17 +0100
X-Google-Sender-Auth: KfExX5es7dQGtFw4ad48XA9_ND0
Message-ID: <AANLkTinz55AAYA7Ltgcs_z+ysedxtavW2xsdw4=4qP0_@mail.gmail.com>
Subject: Re: platform/i2c busses: pm runtime and system sleep
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Rabin Vincent <rabin@rab.in>,
        khilman@ti.com, magnus.damm@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, stern@rowland.harvard.edu,
        linux-i2c@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/19 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> [Me]
>> Both of these problems are solved by elegance if we use runtime
>> PM, since it will provide a hysteresis timeout that can be triggered
>> from interrupt context and call the idling hooks in process context.
>
> So what's the interdependence with the platform bus that was being talked
> about earlier in this thread?

That's about consistency of runtime PM semantics across
different buses as I understand it.

We have both platform bus and AMBA bus devices in the system,
so it is desireable if the semantics of their runtime PM are identical.

If I understand it, the difference is that the platform bus will call
runtime_suspend() on the device even if it was already in suspended
state, so the question is about whether the AMBA runtime PM
should do this too since it is similar to the platform bus, or if it should
go for the more intutive approach of not suspending suspended
hardware.

I think the current patch from Rabin as it stands does the latter, and
is good as it stands. It's the other buses and their drivers that
need patching.

Yours,
Linus Walleij
