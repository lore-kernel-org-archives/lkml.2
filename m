Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab2CNAO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:14:58 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58425 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab2CNAO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:14:56 -0400
MIME-Version: 1.0
In-Reply-To: <201203140110.40671.rjw@sisk.pl>
References: <201203032122.36745.chunkeey@googlemail.com> <201203132042.07794.rjw@sisk.pl>
 <CAPXgP11fWf-0Jkk=d6G+d=sQa-hoX3jUM+K6K4rGYhh0dv1u_w@mail.gmail.com> <201203140110.40671.rjw@sisk.pl>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 14 Mar 2012 01:14:35 +0100
Message-ID: <CAPXgP118s+DuLaATKOq7w=F82GB=8PkwUJDichffXA-Er6Zqvw@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 01:10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, March 14, 2012, Kay Sievers wrote:

>> It is relevant in the sense that the firmware loader should not even
>> know that a uevent *can* cause a usermodehelper exec() if it runs in
>> legacy mode. The firmware loader just has no business in fiddling with
>> the details of driver core legacy stuff. I don't think his warning
>> makes much sense.
>
> But that warning actually triggers for drivers that attempt to use
> request_firmware() during system resume, even though /sbin/hotplug isn't
> used any more.
>
> usermodehelper_is_disabled() means "we are in the middle of system power
> transition" rather than anything else (I agree it should be called
> suspend_in_progress() or something similar these days).

Yeah it's certainly useful to disable the exec() during suspend calls,
much more than using the exec() inhibit flag for the firmware loader
to throw a warning about suspend issues.

Such confusing hacks need at least a comment, that makes this very obvious. :)

Kay
