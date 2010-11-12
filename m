Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab0KLURG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:17:06 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47578 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab0KLURC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:17:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=eGSuZ8KLKMj6cNl8IHLZbjZtjZiXhPSVyINO/TWmbvOe5Wx63sUgvzo/fmar/8uQuQ
         +bNsqAsevT45ype/kTnp2hL3gS1wAPuKdGmQMKIT+SGBfJRydoCHu2/+aiueuSJSDpWp
         P7FdRFHI2ERoVDWwEk+QrEyO7qwvy32eCh0zU=
MIME-Version: 1.0
Date: Fri, 12 Nov 2010 21:17:02 +0100
Message-ID: <AANLkTikLJyr6PREZX-OwOBwMK8uTC2YEu-KHHy0MYFJJ@mail.gmail.com>
Subject: shared transport: only for TI chips?
From: Vitaly Wool <vitalywool@gmail.com>
To: pavan_savoy@ti.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

I've been looking closely at the shared transport implementation to
figure out how applicable it is for similar solutions from other
vendors. My current impression is, this the applicability is very
poor.
For instance, you define the firmware name by querying the chip in a
specific manner. Also, your implementation presumes the chip
implements LL protocol for Bluetooth power saving which might not at
all be the case for other vendors' chips. That's kind of okay as long
as you don't care about power saving; but if you have to support some
other power saving protocol, you're screwed -- there's no such
opportunity in the current ST core.

So the question is, are you at all interested in making the core
generic? I'm ready to come up with some ideas on that if the answer is
positive :)

And if not, we need to consider bringing in something more generic as
there already are several vendors that use Bluetooth for command
encapsulation on similar multi-functional chips.

Thanks,
   Vitaly
