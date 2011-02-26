Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab1BZXRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 18:17:03 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:53318 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1BZXQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 18:16:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=STwHJahQ2F63abQNuikJiCGvvyVIfzWojiFNrVKizOafL8uWq41TEfHPdCkOQHeA7w
         NUmkRr6qGUv0S6V95TcOB91YKWY1HAM0kmOf+sCDIA1hBM1v6HlzE6KpqlSzrVOh0MLw
         C3RXtANxGRTOjKmqxfpBejifk7wklIeOqIA+M=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=bJRh=0N6wP3LJWTQHSXsX4xdE7oOzK0CFcTfc@mail.gmail.com>
References: <4D671556.80607@suse.com>
	<20110225060706.GA12723@merkur.ravnborg.org>
	<AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
	<AANLkTimTm40Sp5-kMaL4d1oXf3CzytZsBCus3DN0jwD-@mail.gmail.com>
	<AANLkTi=bJRh=0N6wP3LJWTQHSXsX4xdE7oOzK0CFcTfc@mail.gmail.com>
Date: Sun, 27 Feb 2011 00:16:58 +0100
Message-ID: <AANLkTik0VoCSHbpZ=CqG8ZoBNKVQuOEKf3bf19uz-tjj@mail.gmail.com>
Subject: Re: [PATCH] Add ``cloneconfig'' target
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 11:57 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Sat, Feb 26, 2011 at 5:47 PM, Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>> On Sat, Feb 26, 2011 at 8:47 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>> Why ? Thing should be kept simple. kconfig's job is not to know about
>>> the trillion file format which exist in the world, even more if the
>>> implementation is made by building a command[0], executing it in a
>>> separate process and reading the output. This is the shell's job. What
>>> may be useful in the contrary would be to eventually teach kconfig to
>>> read from <stdin>.
>>
>> /proc/config.gz is provided by the kernel and its format is defined by
>> kconfig itself which is, as well, part of the kernel (it is not one
>> random format from a pool of a trillion), so it will be nice if
>> kconfig learns how to read its own configuration from there.
>>
> your point being ? kconfig is not only used by the Linux kernel, and
> you cannot expect the feature to only be used in the cozy Linux kernel
> environment.

My point was that supporting reading from a .gz file is not anywhere
near "knowing about the trillion file format which exist in the world"
(and I was not talking about a "hack", see below).

>
>> kconfig only knows about config files (one format). The fact that it's
>> gzipped its irrelevant, any reasonable machine capable of building the
>> kernel has gzip installed.
>>
> again, the average user has no interaction with kconfig directly,
> (s)he uses the top level Makefile target at best. The original patch
> of Jeff is way better than any hack to read a gzip file from kconfig.
> KISS and please don't reinvert the wheel.

I agree with that. I understood that you were against adding support
for reading /proc/config.gz whether patching the Makefile or teaching
kconfig how to do that.

Miguel

>
>  - Arnaud
>
