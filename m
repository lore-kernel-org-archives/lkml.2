Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1JSWbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:31:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab1JSWbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:31:13 -0400
Date: Wed, 19 Oct 2011 15:28:21 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/26] staging: et131x: Put all .c files into one big file
Message-ID: <20111019222821.GB31179@suse.de>
References: <1318954079-16666-1-git-send-email-mark.einon@gmail.com>
 <1318954079-16666-2-git-send-email-mark.einon@gmail.com>
 <20111019204128.GA6152@kroah.com>
 <CANK3SE2AEKhw8zSXn3jtGggYh8+SS1mX7Kaue6+vU+B5VjAxWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANK3SE2AEKhw8zSXn3jtGggYh8+SS1mX7Kaue6+vU+B5VjAxWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 10:28:24PM +0100, Mark Einon wrote:
> On 19 October 2011 21:41, Greg KH <greg@kroah.com> wrote:
> > On Tue, Oct 18, 2011 at 05:07:34PM +0100, Mark Einon wrote:
> >> Created one big .c file for the driver, moving the contents of all
> >> driver .c files into it.
> >>
> >> Signed-off-by: Mark Einon <mark.einon@gmail.com>
> >
> > Something is wrong here, when I try to apply this patch with git, I get
> > the following errors:
> [...]
> >
> > Care to resend it with the file actually deleted?  How are you
> > generating this patch?
> >
> > And, when you resend the series, don't put the [RESEND] in the subject,
> > I had to edit that out in order to apply them properly (which turned out
> > to be a waste of time due to this patch not applying...)
> 
> Apologies Greg, I didn't mean to waste your time.
> 
> I've used this command to generate the patch, in order not to include
> the entire file contents that have been deleted:
> 
> git format-patch -D <to-list> <patches>

I use:
	git format-patch -k -M

If you read the man page for git format-patch, you will see why "-D"
does not work at all for this, and this is why I can't apply these
patches, you are giving me something that is _known_ to not apply:

      -D, --irreversible-delete
	   Omit the preimage for deletes, i.e. print only the header but
	   not the diff between the preimage and /dev/null. The
	   resulting patch is not meant to be applied with patch nor git
	   apply; this is solely for people who want to just concentrate
	   on reviewing the text after the change. In addition, the
	   output obviously lack enough information to apply such a
	   patch in reverse, even manually, hence the name of the
	   option.

> I also assumed RESEND was commonly used for the purpose of resending
> patches. Is this not the case?

Yes, but you did it this way:
	[RESEND][PATCH 02/XX]
and git will just strip off the first [] chunk when applying it.  So
unless I wanted the [PATCH...] portion in the changelog, I had to delete
it by hand.

You can do:
	[RESEND PATCH 03/XX]
and all would be almost ok, but when I sort the emails, it would break
order.

So best is:
	[PATCH 03/XX RESEND]
if you really need the RESEND comment.  Personally, I would only do that
in the [00/XX] patch as that's what counts here.  You aren't resending
because I ignored them, but because there was a problem with them, so
you know I didn't apply those original ones.

hope this helps,

greg k-h
