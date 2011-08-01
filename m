Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1HASdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:33:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:38157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1HASdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:33:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=cv+LqxTz50PXgK2qpvZ++jo8lF/zzAamQrw3Q9dotm0tYpF8PyzUieH+nfnY4kW50
	0IzyEpbDHQPHsZB42GRgw==
MIME-Version: 1.0
In-Reply-To: <20110801125234.GE14343@redhat.com>
References: <1311271873-10879-1-git-send-email-zakmagnus@google.com>
	<20110722195340.GF3765@redhat.com>
	<CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
	<20110725124451.GA2866@redhat.com>
	<CAAuSN93Qjk4eEAvm_Xn=O-0t+qhAyKmxy6HyPuyzJ35tX2u_CQ@mail.gmail.com>
	<20110729205538.GD14343@redhat.com>
	<CAAuSN93ouWrPn9xWb9Zd3E2Dp0hQxC4JmFH1utbyy1_aMnfkLA@mail.gmail.com>
	<20110801125234.GE14343@redhat.com>
Date: Mon, 1 Aug 2011 11:33:24 -0700
Message-ID: <CAAuSN92UAjuJXprBAj9z0sekk=iBWGe3PP88z8NmrZ5fExOyjg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
From: ZAK Magnus <zakmagnus@google.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay... So this is a problem we need to solve. Does there exist a good
way to output a stack trace to, say, a file in /proc? I think that
would be an appealing solution, if doable.

On Mon, Aug 1, 2011 at 5:52 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, Jul 29, 2011 at 04:12:32PM -0700, ZAK Magnus wrote:
>> Are you saying that any call to printk() will touch the watchdogs? I
>> wasn't aware of that and it doesn't seem to comply with my
>> observations too well, either. Then again, at the moment I don't
>> understand some of the things I'm currently seeing so I could just be
>> wrong.
>
> I believe the serial console write is the source of all the
> touch_nmi_watchdogs that result from a printk.
>
> drivers/tty/serial/8250.c::serial8250_console_write()
>
> Cheers,
> Don
>
