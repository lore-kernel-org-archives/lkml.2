Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1FBNDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:03:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63647 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1FBNDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:03:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
 <BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com> <m18vtkq57c.fsf@fess.ebiederm.org>
 <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com> <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 2 Jun 2011 10:02:50 -0300
Message-ID: <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add support for poll()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 9:43 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> The alternative is to have a process constantly polling and reading
>> the file, which is nothing we even want to think about in 2011.
>
> Or to manage it properly.

What if the user decides do invoke sethostname syscall "by hand"?
Hostname would change beneath any other process that is trying to
manage it properly. What this patch does is to notify that process
that something happened.


>> It's just another special case to bring us out of the UNIX stone age
>> of doing things. :)
>
> Unfortunately not. It's a misguided attempt to follow stone age Unix 'one
> short name' policy. Forget utsname node names, they are a historical
> quirk of UUCP and friends and on many OS platforms will be limited to 15
> chars !
>
> As to poll in general I can see some of the other proc files being
> more relevant, eg for process monitoring tools being able to poll
> in /proc/<pid> and some of the proc/sys and sysctl data that does change
> meaningfully. Utsname however is not one of those things.
>

With this patch in, if anyone wants to manage a file under /proc/sys
there's really a small amount of code to write. He only has to define
the new poll struct for that file.


Lucas De Marchi
