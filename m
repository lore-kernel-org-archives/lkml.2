Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab0JZKlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:41:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab0JZKlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:41:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Fulghum <paulkf@microgate.com>
Subject: Re: [PATCH] n_hdlc fix read and write locking
Date: Tue, 26 Oct 2010 12:40:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
References: <1288030959.19909.28.camel@x2.microgate.com> <201010252231.06794.arnd@arndb.de> <4CC6104B.7040204@microgate.com>
In-Reply-To: <4CC6104B.7040204@microgate.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010261240.47907.arnd@arndb.de>
X-Provags-ID: V02:K0:xu2YzIFqE4F6F3KEgmTQotvgzvYXEo9+a+26wB15fms
 3+a1errB75VgPoEiNrFWq45rSYUHwjwF+cCmYyQAX1HRNTcUNJ
 NIWphxA6JGuffrTVkvrs5y/Mebf+jwPjX0CO6XqjG/IoYfOMI5
 KeDz0AjoU5pLsUWjP+43Q2oOh5hEiyvCVcLIX6GAYPtgj1iW/k
 ySGhzmR7zlc9u28QDnolw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 October 2010, Paul Fulghum wrote:
> On 10/25/2010 3:31 PM, Arnd Bergmann wrote:
> 
> > Would it be possible to express the same using
> > wait_event_interruptible()?
> 
> Yes if I embed an assignment in the event expression:
> 
> rc = wait_event_interruptible(&wait, (buf = get_buf()));
> if (!rc)
>         process_buf(buf);
> 
> Is that considered acceptable?

I'd do it if it makes the code more readable. We need the patch
for the stable release, so it really should be obvious not to
introduce new bugs. I could not fully understand the version
you posted, so if you can make it easier to understand by using
wait_event, please do so. If you think that putting the
assignment into the macro argument outweighs the advantage from
the wait_event, just keep your version.

	Arnd
