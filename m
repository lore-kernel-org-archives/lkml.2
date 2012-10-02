Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab2JBQd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:33:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48713 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab2JBQdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121002100319.59146693@redhat.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Oct 2012 09:33:03 -0700
X-Google-Sender-Auth: NGvtaPn5tV-DPsfR0jIb1aGQXc8
Message-ID: <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>
Cc: Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 6:03 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> I basically tried a few different approaches, including deferred probe(),
> as you suggested, and request_firmware_async(), as Kay suggested.

Stop this crazy. FIX UDEV ALREADY, DAMMIT.

Who maintains udev these days? Is it Lennart/Kai, as part of systemd?

Lennart/Kai, fix the udev regression already. Lennart was the one who
brought up kernel ABI regressions at some conference, and if you now
you have the *gall* to break udev in an incompatible manner that
requires basically impossible kernel changes for the kernel to "fix"
the udev interface, I don't know what to say.

"Two-faced lying weasel" would be the most polite thing I could say.
But it almost certainly will involve a lot of cursing.

> However, for 3.7 or 3.8, I think that the better is to revert changeset 177bc7dade38b5
> and to stop with udev's insanity of requiring asynchronous firmware load during
> device driver initialization. If udev's developers are not willing to do that,
> we'll likely need to add something at the drivers core to trick udev for it to
> think that the modules got probed before the probe actually happens.

The fact is, udev made new - and insane - rules that are simply
*invalid*. Modern udev is broken, and needs to be fixed.

I don't know where the problem started in udev, but the report I saw
was that udev175 was fine, and udev182 was broken, and would deadlock
if module_init() did a request_firmware(). That kind of nested
behavior is absolutely *required* to work, in order to not cause
idiotic problems for the kernel for no good reason.

What kind of insane udev maintainership do we have? And can we fix it?

Greg, I think you need to step up here too. You were the one who let
udev go. If the new maintainers are causing problems, they need to be
fixed some way.

                Linus
