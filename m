Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1FBNY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:24:28 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48636 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab1FBNY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=K52FRqgNQ1UR05RPrMzlKscuUi+yheSjjAq8Hz4zLkVWcAXM9Z+1AAEq6WbfNO6K+Y
         AcV4+susXfQZJcMc/w+6Vk+z2tnfFZ/BaQO5TjmP7DckMpVfzrtueMnYeU6Zq2mjkkGp
         IoN4Izs4p4i47dyexTVY4NvOgjXlinxg3lVvU=
MIME-Version: 1.0
In-Reply-To: <20110602141234.4f5bffef@lxorguk.ukuu.org.uk>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
 <BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com> <m18vtkq57c.fsf@fess.ebiederm.org>
 <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com> <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
 <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com> <20110602141234.4f5bffef@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 2 Jun 2011 15:24:11 +0200
Message-ID: <BANLkTikTVm7OxyT+g1yUZs5C_PiF9EdJAg@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add support for poll()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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

On Thu, Jun 2, 2011 at 15:12, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > Or to manage it properly.
>>
>> What if the user decides do invoke sethostname syscall "by hand"?
>> Hostname would change beneath any other process that is trying to
>> manage it properly. What this patch does is to notify that process
>> that something happened.
>
> That is a stupid argument. Shall we extend it to its logical idiotic end
> and ask
>
> "What if the user decides to recompile their kernel without sysfs poll
> support ?"

Alan please! This is not something we haven't thought through.

> You have to be root to run sethostname, at which point you are
> realistically at the command line, a superuser and you know what you are
> doing (eg using sethostname for non IP network naming, or cluster id, or
> other stuff).

Please stay to the actual problem this patch tries to resolve.

>> With this patch in, if anyone wants to manage a file under /proc/sys
>> there's really a small amount of code to write. He only has to define
>> the new poll struct for that file.
>
> Sure - and there is an 8 byte cost per sysctl node (of which we have
> rather a lot), and we really need to tackle sysfs not sysctl anyway.

It is. And we will very likely need poll() for other things in
/proc/sys too. It's the cost of providing functionality we just need
today.

I could understand arguing about things like: void *extra1; void
*extra2; in that very same structure, but not about something that
can't really be solved otherwise.

> I'm not averse to pollable sysfs/sysctl nodes at all although the memory
> hit on sysfs is going to be tricky to manage and need clever code.

Yeah, but not related to the problem this patch tries to solve.

> I just think the utsname is a completely misguided example and whoever is
> trying to do it doesn't actually understand the limits of utsname.

We are not talking about limits of a certain infrastructure. It is
used, it will not go away, we need to support it.

This is about propagating in-kernel state changes to userspace. Please
open a different conversation for everything else.

Thanks,
Kay
