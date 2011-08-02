Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1HBXQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 19:16:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1HBXQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 19:16:52 -0400
Date: Tue, 2 Aug 2011 16:16:41 -0700
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, neilb@suse.de
Subject: Re: [PATCH] sysctl: add support for poll()
Message-ID: <20110802231641.GA2598@suse.de>
References: <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
 <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
 <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
 <m1hb88e3qs.fsf@fess.ebiederm.org>
 <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com>
 <20110608151732.2b321b9a.akpm@linux-foundation.org>
 <BANLkTinXwE0K5nJ649rhNxN06KvwLNDeCA@mail.gmail.com>
 <1307981153.1449.19.camel@mop>
 <CAMOw1v5veDqE+=gbNBn3juXHOOp764d7F20XtwUJXZoBW45zyg@mail.gmail.com>
 <CAPXgP12sxLmPXzXx_Qgf=JakmiZcuiMGmMKB8RG4sFU_U5f=jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP12sxLmPXzXx_Qgf=JakmiZcuiMGmMKB8RG4sFU_U5f=jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 12:53:33AM +0200, Kay Sievers wrote:
> On Tue, Jul 26, 2011 at 04:17, Lucas De Marchi
> <lucas.demarchi@profusion.mobi> wrote:
> > On Mon, Jun 13, 2011 at 1:05 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >> On Thu, 2011-06-09 at 15:16 +0200, Kay Sievers wrote:
> >>> On Thu, Jun 9, 2011 at 00:17, Andrew Morton <akpm@linux-foundation.org> wrote:
> >>
> >>> > We already have several pollable procfs files, such as
> >>> > fs/proc/base.c:mounts_poll() and I think drivers/md has one.  I do
> >>> > think that any work in this area should end up with those custom
> >>> > make-procfs-pollable hacks being identified and removed.
> >>>
> >>> For these files we can probably move the event counter into the
> >>> seq_file structure, and get rid of the dance to kmalloc it and assign
> >>> it to seq_file->private. That might simplify the logic a bit.
> >>>
> >>> [Adding Neil, to get his opinion of moving 'event' so seq_file and get
> >>> rid of the malloc dance]
> >>
> >> I guess, we could do something like this, which looks quite a bit
> >> simpler by moving the poll event counter into the dynamically allocated
> >> seq_file structure itself, instead of having private structures
> >> allocated on top to just carry the counter (patch is just
> >> compile-tested).
> >
> > Now that this cleanup made its way, could we look again to to the
> > pollable sysctl implementation?
> 
> Can we please get support for poll() for /proc/sys files merged? Just
> like we do that for /proc already.
> 
> We like to have notifications triggered by the kernel for selected
> files in /proc/sys.
> 
> I don't really see any technical reasons to hold this back.

Care to resend the patch so we can queue it up for 3.2?

thanks,

greg k-h
