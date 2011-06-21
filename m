Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab1FUUXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:23:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60539 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab1FUUXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:23:10 -0400
Date: Tue, 21 Jun 2011 21:22:53 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mike Waychison <mikew@google.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, Matt_Domsch@dell.com
Subject: Re: [PATCH 3/3] efi: Add support for using efivars as a pstore
 backend
Message-ID: <20110621202253.GA14828@srcf.ucam.org>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
 <1307389135-8150-3-git-send-email-mjg@redhat.com>
 <4DFFEC3B.90001@google.com>
 <20110621151040.GB7476@srcf.ucam.org>
 <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=qmS090MK=sx=xMN95zD5AtNkuLG_g092oVXJezoRCYA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:16:29PM -0700, Mike Waychison wrote:
> On Tue, Jun 21, 2011 at 8:10 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > You don't. I'll be posting a patch for pstore that lets you choose the
> > backend - that can be used to disable this functionality at boot time.
> 
> Hmm.  Okay.
> 
> > In theory, but I don't really understand the benefit. You can't have
> > more than one efivars implementation on a system.
> 
> It's just cleaner and keeps the state of things in a single place,
> rather than in globals.  I just cleaned all this global state up, and
> would like to keep it clean.

Ok, I'll do that.

> > The variable name is fundamentally meaningless. Just think of it as a
> > binary representation of the data. Formatting it as a signed integer
> > would break the parsing.
> 
> What do you mean it would break the parsing?

Actually, thinking about it, it'd be ok - but I'll take Tony's 
suggestion of just switching it to an unsigned.

> > The idea is to check for prefixes. If efi_name[i] is non-zero but
> > VariableName[i] is zero then we'll break due to them not matching, which
> > is the desired behaviour.
> 
> That's fine, but it's not what the code does.  It's also a lot clearer
> to the reader if this isn't open coded.  We should also be checking
> that this variable is ours with a guid check.  I'd be happier with a
> utf16_strncmp here.  Will follow up with patches that stack on top of
> yours.

Ok.

> > Userspace really ought to depend on efivars being available on EFI
> > systems. I don't think losing the ability to unload it is a big loss.
> 
> I don't know of any such dependencies.  Am I missing something?

Having a situation where efivars can appear and disappear while 
efibootmgr (for instance) is using it is kind of awkward. In the long 
run we'll probably need to interface with more EFI variables to play 
nice with the platform firmware (Apple have some expectations about this 
kind of thing), so we'll want to be able to guarantee it's there at boot 
time and shut down. And, as Tony says, the pstore use case does pretty 
much expect backends to be there.

> I'll follow up with more patches that apply on top of yours.  I'm not
> happy with the string operations in the driver as it is, and I've
> cleaned some of this up.  Feel free to collapse whatever is needed
> from them into your series or pick them up as is.

Gladly. Thanks!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
