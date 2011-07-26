Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1GZCSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 22:18:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64161 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab1GZCSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 22:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <1307981153.1449.19.camel@mop>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
 <BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com> <m18vtkq57c.fsf@fess.ebiederm.org>
 <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com> <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
 <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com> <m1hb88e3qs.fsf@fess.ebiederm.org>
 <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com> <20110608151732.2b321b9a.akpm@linux-foundation.org>
 <BANLkTinXwE0K5nJ649rhNxN06KvwLNDeCA@mail.gmail.com> <1307981153.1449.19.camel@mop>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Mon, 25 Jul 2011 23:17:48 -0300
Message-ID: <CAMOw1v5veDqE+=gbNBn3juXHOOp764d7F20XtwUJXZoBW45zyg@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add support for poll()
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>,
        neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 1:05 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, 2011-06-09 at 15:16 +0200, Kay Sievers wrote:
>> On Thu, Jun 9, 2011 at 00:17, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> > We already have several pollable procfs files, such as
>> > fs/proc/base.c:mounts_poll() and I think drivers/md has one.  I do
>> > think that any work in this area should end up with those custom
>> > make-procfs-pollable hacks being identified and removed.
>>
>> For these files we can probably move the event counter into the
>> seq_file structure, and get rid of the dance to kmalloc it and assign
>> it to seq_file->private. That might simplify the logic a bit.
>>
>> [Adding Neil, to get his opinion of moving 'event' so seq_file and get
>> rid of the malloc dance]
>
> I guess, we could do something like this, which looks quite a bit
> simpler by moving the poll event counter into the dynamically allocated
> seq_file structure itself, instead of having private structures
> allocated on top to just carry the counter (patch is just
> compile-tested).

Now that this cleanup made its way, could we look again to to the
pollable sysctl implementation?


thanks
Lucas De Marchi
