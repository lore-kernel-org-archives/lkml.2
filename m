Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2B0BET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 20:04:19 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:48916 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316Ab2B0BES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 20:04:18 -0500
Date: Sun, 26 Feb 2012 17:04:18 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrei Warkentin <andreiw@vmware.com>
Message-ID: <190287371.1567191.1330304658088.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4F4A3A8D.7030700@windriver.com>
Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Original Message -----
> From: "Jason Wessel" <jason.wessel@windriver.com>
> To: "Andrei Warkentin" <andreiw@vmware.com>
> Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
> Sent: Sunday, February 26, 2012 8:58:37 AM
> Subject: Re: [PATCH] KDB: Fix usability issues relating to the 'enter' key.

> 
> Andrei, if you agree with the attached patch, I'll put it in the
> merge queue.  If you find problems we can go another iteration. :-)
>

Nak. As I've mentioned in my original email, I went down this route as well, only
to ask the question of why the special ENTER code was there, since all it did
was introduce problems elsewhere (like repeat ENTER handling, KP ENTER key...).
This is exactly why my solution was to get rid of the special ENTER code altogether.

The code in kgdboc already will do input device reset on kdb exit, so there is no need
to explicitely empty out the keyboard FIFO on every ENTER.

Thanks,
A
