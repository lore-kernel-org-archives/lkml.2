Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2EHSNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:13:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36381 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2EHSM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <4FA838D2.9000908@suse.cz>
References: <20120503212151.568.91854.stgit@bob.linux.org.uk>
 <20120503212219.568.15653.stgit@bob.linux.org.uk> <CA+1xoqezLCQh_fqJ1iNAs25X7Fm24W=-0J8zTZuVVJQnWTtSLg@mail.gmail.com>
 <20120507171126.5beddc27@pyramind.ukuu.org.uk> <1336408208.3638.15.camel@lappy>
 <20120507174240.4209c5cb@pyramind.ukuu.org.uk> <CA+1xoqez0PaX2KBHHN-etztwbFoU1cKx3NwMXX+PO4SguA3bRg@mail.gmail.com>
 <4FA838D2.9000908@suse.cz>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 8 May 2012 20:12:37 +0200
Message-ID: <CA+1xoqdi1Jdkrjtj9bmnDfs4Ok=o=AsmpP=MY0V8cDXjcSNm1w@mail.gmail.com>
Subject: Re: [PATCH 3/3] tty_lock: Localise the lock
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 11:04 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> On 05/07/2012 07:00 PM, Sasha Levin wrote:
>>> So whatever your trace is showing, that's not the bug. Something more
>>> complicated would appear to be afoot.
>>
>> Oddly enough, tty != tty->link, but the lockdep warning triggers.
>>
>> Any idea why it might happen?
>
> I think so, both locks are the same lockdep class. So lockdep thinks it
> is the same lock. However this is a false positive. I guess we need
> mutex_lock_nested...

It looks like it causes an actual deadlock, and hung_tasks screams if
left alone for a bit, so it doesn't look like a lockdep issue.
