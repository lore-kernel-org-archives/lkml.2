Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab1FBMGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:06:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44701 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab1FBMGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=K8Eh1henyok18ax9fJQOP3ePG2dKAjbKIVBizzoxYylkrnE2EsJcexf0/z1ykfWEQI
         7pkIO8hvzwmat0JRUb9JmBGQrN+R3gjZJlUSL2VFNcFadJc5IDm5ycCJ2nv6I+NfSjDP
         Mo90zRmez/ih0JKaHauFFdH/yMWpmBQ/x4K7w=
MIME-Version: 1.0
In-Reply-To: <m18vtkq57c.fsf@fess.ebiederm.org>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
 <BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com> <m18vtkq57c.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 2 Jun 2011 14:06:30 +0200
Message-ID: <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add support for poll()
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 05:31, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>
>> CC'ing people as suggested by get_maintainer.pl
>>
>> On Wed, Jun 1, 2011 at 9:14 AM, Lucas De Marchi
>> <lucas.demarchi@profusion.mobi> wrote:
>>> Adding support for poll() in sysctl fs allows userspace to receive
>>> notifications when an entry in sysctl changes. This way it's possible to
>>> know when hostname/domainname is changed due to the respective syscall
>>> has been called or its file under /proc/sys has been written to.
>
> Why do you want to do this?  What advantage does this bring to
> userspace?

Host names are dynamic, can change during system runtime by dhcp or
similar setups, or just get changed by the user.

System management tools/services needs to track these changes to
propagate the actual host name into the running services. It's the
same like we dynamically track /proc/mounts, /proc/swaps, or any other
stuff that can change underneath us, and forces other things to adapt
to the changing environment.

> That feels like a pretty big special case.

The alternative is to have a process constantly polling and reading
the file, which is nothing we even want to think about in 2011.

It's just another special case to bring us out of the UNIX stone age
of doing things. :)

Kay
