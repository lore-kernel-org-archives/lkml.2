Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1ISGcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 02:32:43 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:24909 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab1ISGcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 02:32:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACrfdk55LAXJ/2dsb2JhbABCpzp4gVMBAQUyASMjEAgDDgouFCUDIRO8Ug6GagScGYhv
Date: Mon, 19 Sep 2011 16:32:26 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, linux-man@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] fallocate.2: add FALLOC_FL_PUNCH_HOLE flag definition
Message-ID: <20110919063226.GI15688@dastard>
References: <1289840876-3546-1-git-send-email-josef@redhat.com>
 <CAKgNAkj-jPR-9hyuxrJ74uu3Kdv9bATrfCUedoty4dJOCh2GcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKgNAkj-jPR-9hyuxrJ74uu3Kdv9bATrfCUedoty4dJOCh2GcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 07:08:17AM +0200, Michael Kerrisk wrote:
> Hi Josef (Dave C, please also note comments below),
> 
> On Mon, Nov 15, 2010 at 6:07 PM, Josef Bacik <josef@redhat.com> wrote:
> > This patch adds the relevant documenation for using fallocate with the
> > FALLOC_FL_PUNCH_HOLE mode.  This information comes from the implementation of
> > FALLOC_FL_PUNCH_HOLE that I've posted along with this man page update to outline
> > the definition for hole punching.  Obviously this patch is dependant upon the
> > current implementation being accepted.  Thanks,
> >
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  man2/fallocate.2 |   15 ++++++++++++---
> >  1 files changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/man2/fallocate.2 b/man2/fallocate.2
> > index 42eefbd..1b28916 100644
> > --- a/man2/fallocate.2
> > +++ b/man2/fallocate.2
> > @@ -31,9 +31,8 @@ bytes.
> >
> >  The
> >  .I mode
> > -argument determines the operation to be performed on the given range.
> > -Currently only one flag is supported for
> > -.IR mode :
> > +argument determines the operation to be performed on the given range, the
> > +value can be one of the following:
> >  .TP
> >  .B FALLOC_FL_KEEP_SIZE
> >  This flag allocates and initializes to zero the disk space
> > @@ -50,6 +49,16 @@ the file size (as reported by
> >  .BR stat (2))
> >  even if it is less than
> >  .IR offset + len .
> > +.TP
> > +.B FALLOC_FL_PUNCH_HOLE
> > +This flag de-allocates the disk space within the range specified by
> > +.I offset
> > +and
> > +.IR len .
> > +This call preserves the file size (as reported by
> > +.BR stat (2)),
> > +the only change will be to the amount of space used by the file.  After a
> > +successful call, subsequent reads from this range will return 0's.
> >  .\"
> >  .\" Note from Amit Arora:
> >  .\" There were few more flags which were discussed, but none of
> > --
> > 1.6.6.1
> 
> Thanks for this patch. As noted in another mail, Lucian also sent a
> patch for FALLOC_FL_PUNCH_HOLE, and I applied his patch first, and
> then added some pieces from yours, as well as some of my own edits.
> 
> However, the addition of a second class of operation to the man page
> made it clear that some significant restructuring of the page is
> required. So I substantially reworked the page, including the
> preexisting material on the default "file allocation" operation (Dave
> C please note).
> 
> Josef, Lucian, could I ask you to check ("man -l <file>") the final
> text (below) for FALLOC_FL_PUNCH_HOLE (including the EPERM error under
> ERRORS)?
> 
> Dave, could I ask you to review my reworked text for the "Allocating
> disk space" subsection?

Looks OK to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
