Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0JaWFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 18:05:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57534 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0JaWFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 18:05:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JpdV+QVoATEyA9M39KPv5LGemy+unQWyapHyV5SwgzVhmtEdtPqNuZarl2dBEUYWE/
         0x5wvdWPWJKjhfT/iXEVaA1mxyPYbWTmQVTv0B88m+QIDP3voAwka/0QyonIeExe0Q5P
         gxNk1HEyOVFs1aOzC3yQuXl0X8UXtN9i8VvAg=
MIME-Version: 1.0
In-Reply-To: <1288402042.29632.50.camel@gandalf.stny.rr.com>
References: <20101029054310.790179545@goodmis.org>
	<20101029054423.498608001@goodmis.org>
	<AANLkTi=a8dp-WUNHAkx2fZ5GgNHmDw+ee7MDeUSL44Z0@mail.gmail.com>
	<1288402042.29632.50.camel@gandalf.stny.rr.com>
Date: Sun, 31 Oct 2010 18:05:53 -0400
Message-ID: <AANLkTi=JXFppmiyyo=Hc614=FpDhOO4h8SLTs=CUOvQv@mail.gmail.com>
Subject: Re: [PATCH 1/5] [PATCH 1/5] kconfig: Make localmodconfig handle
 environment variables
From: Arnaud Lacombe <lacombar@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 29, 2010 at 9:27 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-10-29 at 20:26 -0400, Arnaud Lacombe wrote:
>> Hi,
>
>> Technically, it is _not_ an environment variable; it is a kconfig
>> symbol's name. In this particular case, both name collide and the
>> kconfig symbol happens to get its default value from the environment.
>> The real fixes, from my point of view, would be to have a perl binding
>> of the kconfig backend and get rid of read_kconfig(). That said, your
>> patch is broken if a symbol happen not to match an environment
>> variable (both in name and value).
>
> That sounds like a proper fix. Unfortunately, I don't have the time to
> work on this now, and although this fix works by coincidence, it
> never-the-less works, as suppose to just having localmodconfig crash.
>
yes, sure.

> But you are right. After KS and Plumbers, I'll work on doing something
> like that. That can probably solve some of the other issues I'm having
> (still keeping too many modules enabled).
>
I have some work in progress in this area: cleanup, better split
between the kconfig backend and frontend, and eventually a perl
binding. That would all be an interesting goal for .38 :-)

Currently I got the parser working within perl, but I'm not really
really sure of what I can currently do with it and how the whole thing
interface to one another :)

 - Arnaud
