Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab1JMJem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:34:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33153 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1JMJek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:34:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+O4pC+Qo0VVM26RZXkKs18vJ-uG-YGp1vxtKBr0nzRSOitPtA@mail.gmail.com>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
	<20111012141724.GA17414@suse.de>
	<CA+O4pCJ3rte3eHUy44JWsYo5BqVzRNXojLYLo6uOd8cRQGs=LQ@mail.gmail.com>
	<20111012203337.GA14572@suse.de>
	<CA+O4pCKfem5nAQvpRWBZp21XsE6Z3Nn1iDW9yosuQ3fLqhtZ1A@mail.gmail.com>
	<CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
	<CAHFNz9JUV6wabQxsvrxPRX6q41sWNMDy8DJcOpNTecNTbL=XaQ@mail.gmail.com>
	<CA+O4pCJ2gDicdC7BbCbo0m3xdCX0cdhY-Azn9aqu6+C58u0kgQ@mail.gmail.com>
	<CAHFNz9+a4PjsAoBYF-bJ9nSOzNtEVq23UJzxSTxo=fdmSGOJPw@mail.gmail.com>
	<CA+O4pC+Qo0VVM26RZXkKs18vJ-uG-YGp1vxtKBr0nzRSOitPtA@mail.gmail.com>
Date: Thu, 13 Oct 2011 15:04:39 +0530
Message-ID: <CAHFNz9JE6FcBHyrSFEnnAjKsPtHWnYush-UMsg-tBLQfQ=Zwaw@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Manu Abraham <abraham.manu@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> yes the PID is 0x1fff which are null packets over there, so those ones are okay.
> Main point is it works and it would even comply with certain HW specs (the other
> device points out about 256*188 bulk transfer buffer sizes.
>
> Now it would be the time for some people to open their eyes and get
> that patch in.


Call me dumb, but it still defies my logic why there would be stream
corruption with a smaller buffer size, if the driver is handling the
stream correctly.

I can probably imagine that there could be a likely chance, user space
would have to poll more often in case with smaller buffers, while
making it larger you increase the latency of the stream; that being a
double edged blade.


> The maximum transfer buffer size was derived from our other device which can
> do the flexible setting. According to the specification it is no magic value.


So, with your single device, if you were to make changes to some
"magical constants"; and tomorrow if someone wants to have
modifications again, what would you do ? If that change is a must,
maybe it should be configurable in some way, rather than having
another fixed magical number.


Regards,
Manu
