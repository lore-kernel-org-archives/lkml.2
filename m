Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1FNDwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 23:52:43 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62734 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1FNDwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 23:52:42 -0400
Date: Tue, 14 Jun 2011 00:53:13 -0300
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
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
Subject: Re: [PATCH] sysctl: add support for poll()
Message-ID: <20110614035313.GA1229@vigoh>
References: <BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com>
 <m18vtkq57c.fsf@fess.ebiederm.org>
 <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
 <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
 <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
 <m1hb88e3qs.fsf@fess.ebiederm.org>
 <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
 <20110608151732.2b321b9a.akpm@linux-foundation.org>
 <BANLkTinXwE0K5nJ649rhNxN06KvwLNDeCA@mail.gmail.com>
 <1307981153.1449.19.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307981153.1449.19.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kay Sievers <kay.sievers@vrfy.org> [2011-06-13 18:05:51 +0200]:

> On Thu, 2011-06-09 at 15:16 +0200, Kay Sievers wrote:
> > On Thu, Jun 9, 2011 at 00:17, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > We already have several pollable procfs files, such as
> > > fs/proc/base.c:mounts_poll() and I think drivers/md has one.  I do
> > > think that any work in this area should end up with those custom
> > > make-procfs-pollable hacks being identified and removed.
> > 
> > For these files we can probably move the event counter into the
> > seq_file structure, and get rid of the dance to kmalloc it and assign
> > it to seq_file->private. That might simplify the logic a bit.
> > 
> > [Adding Neil, to get his opinion of moving 'event' so seq_file and get
> > rid of the malloc dance]
> 
> I guess, we could do something like this, which looks quite a bit
> simpler by moving the poll event counter into the dynamically allocated
> seq_file structure itself, instead of having private structures
> allocated on top to just carry the counter (patch is just
> compile-tested).
> 
> Thanks,
> Kay
> 
> ---
>  drivers/md/md.c               |   26 ++++++++------------------
>  fs/namespace.c                |    4 ++--
>  fs/proc/base.c                |    2 +-
>  include/linux/mnt_namespace.h |    1 -
>  include/linux/seq_file.h      |    1 +
>  mm/swapfile.c                 |   29 ++++++++---------------------
>  6 files changed, 20 insertions(+), 43 deletions(-)

I've successfully tested this on top of 3.0-rc3 for /proc/mounts and
/proc/swaps. I've booted with systemd (that depends on mounts and swaps
being pollable) and created a small test using epoll.


Lucas De Marchi
