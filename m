Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1FBNCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:02:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40346 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab1FBNCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=QHHkdDX02i86eK1QCxBZfrWdL2sUEpnMYhv3SegI/7C66tspp/jMHe+3CmX5i0d1fF
         WKuhl78ZbJ0evvAW308WNnuw9qwxwuaFvfOLxYvXmKflHJO4x31jZcGVXPy/GDCCI71Y
         dX/o9/FzWrhRNMuG4Jm0ZLECAsZapWa+zqtnU=
MIME-Version: 1.0
In-Reply-To: <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
 <BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com> <m18vtkq57c.fsf@fess.ebiederm.org>
 <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com> <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 2 Jun 2011 15:01:55 +0200
Message-ID: <BANLkTimnrLAPUA5Jt9Tqfdpb6fk8DDFGWw@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add support for poll()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 14:43, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> So this all belongs in conman, network manager and other similar
> systems and I'd suggest they try and deal with the meaningful IP world
> questions of "what list of names do I posess for purpose X on network Y"
> and "is this one of my names on ..."

Higher level interfaces already live in the system services to set and
get the names in various ways. But we also need to support changes by
the old and simple tools. Calling hostname(1) must work just like
everything else. It changes state in the kernel, we need to know it
and adapt to it.

>> The alternative is to have a process constantly polling and reading
>> the file, which is nothing we even want to think about in 2011.
>
> Or to manage it properly.

That's just a dream. We do it properly, but we have no control over
everything. You've been yourself in that position, and have seen that
some stuff will 'never' change, we better just support it instead of
hoping it will not be used. Especially when it's that damn simple and
clean.

>> It's just another special case to bring us out of the UNIX stone age
>> of doing things. :)
>
> Unfortunately not. It's a misguided attempt to follow stone age Unix 'one
> short name' policy. Forget utsname node names, they are a historical
> quirk of UUCP and friends and on many OS platforms will be limited to 15
> chars !

That's not a problem. We support pretty names in the higher stack just
fine, but there is a tone of stuff that depends on gethostname(),
sethostname() and we have to support that.

> As to poll in general I can see some of the other proc files being
> more relevant, eg for process monitoring tools being able to poll
> in /proc/<pid> and some of the proc/sys and sysctl data that does change
> meaningfully.

Yeah, being able to watch a pid with such a simple interface would be
great to have.

> Utsname however is not one of those things.

I think it is.

As always, what are the alternatives you would propose, to watch
sethostname() changes to the system. And 'it should not be used', or
'it should be centrally intercepted' does not count, the reality will
go on without such rules.

Kay
