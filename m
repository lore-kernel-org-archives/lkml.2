Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2B1RYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:24:43 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:50381 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab2B1RYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:24:42 -0500
Date: Tue, 28 Feb 2012 09:24:41 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrei Warkentin <andreiw@vmware.com>,
        Andrei Warkentin <andrey.warkentin@gmail.com>
Message-ID: <225599809.1658960.1330449881619.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4F4CDC50.8070505@windriver.com>
Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

----- Original Message -----
> From: "Jason Wessel" <jason.wessel@windriver.com>
> To: "Andrei Warkentin" <andrey.warkentin@gmail.com>
> Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Andrei Warkentin" <andreiw@vmware.com>
> Sent: Tuesday, February 28, 2012 8:53:20 AM
> Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
> 
> 
> I think we are a lot closer this time.  I attached a new patch based
> on your prior version.
> 
> This is the wrong place to do this.  The cleanup needs to get
> executed
> any time you are going to leave kdb_main(), because there are a few
> conditions like cpu switch, and transition to kgdb where you would
> leak the enter code on to the buffer handler without ever returning
> to
> the OS.  Also if you did not set CONFIG_KDB_KEYBOARD your patch did
> not compile properly.  We could have fixed this by moving the code to
> the input cleanup in kgdboc, but this is not needed at all if you
> take a look at the revised version.
> 

Oh I see now. Okay. I'll keep this in mind.

> >
> >
> > Fixed previous regression where if kbd was not used
> > to 'g' + ENTER, the cleanup code would hang.
> 
> 
> Was this a regression in the out of tree code or something in the
> mainline kdb?

The first patch I sent out didn't have the kbd_last_ret bit. I found this
while using netkgdb and kgdboc together, but I'm certain this would
also apply if you ran kgdboc=ttyS0,kbd and broke in/resumed from serial
without ever touching the i8042 keyboard.

> 
> I added kbd_last_ret = 0; right here so this cannot get triggered a
> second time if the kdb main loop is entered and exited without going
> to the shell (which can happen on a soft single step operation on
> some archs).
> 

Looks good to me! I gave it a spin as well.

Acked-by: Andrei Warkentin <andrey.warkentin@gmail.com>

A
