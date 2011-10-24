Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1JXWwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:52:46 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13397 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1JXWwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:52:44 -0400
Date: Tue, 25 Oct 2011 00:57:16 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: Joe Perches <joe@perches.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, davej@redhat.com
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
In-Reply-To: <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1110250055310.19795@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net> <1319496149.2094.3.camel@Joe-Laptop> <CAFLxGvyh-u0Bg5_R4upMa=bM4H__i=dbvtLihFY+M+OEKdJL9w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1676111565-1319497037=:19795"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1676111565-1319497037=:19795
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 25 Oct 2011, richard -rw- weinberger wrote:

> On Tue, Oct 25, 2011 at 12:42 AM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2011-10-25 at 00:38 +0200, Jesper Juhl wrote:
> >> The first argument to kmalloc() is the size, the second is
> >> flags. pmcraid_chr_ioctl() gets this wrong and swaps the
> >> arguments. This patch corrects the mistake.
> >>
> >> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> >> ---
> >>  drivers/scsi/pmcraid.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >>  compile tested only.
> >>
> >> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> >> index d079f9a..da19bdf 100644
> >> --- a/drivers/scsi/pmcraid.c
> >> +++ b/drivers/scsi/pmcraid.c
> >> @@ -4103,7 +4103,7 @@ static long pmcraid_chr_ioctl(
> >>       struct pmcraid_ioctl_header *hdr = NULL;
> >>       int retval = -ENOTTY;
> >>
> >> -     hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
> >> +     hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
> >>
> >>       if (!hdr) {
> >>               pmcraid_err("faile to allocate memory for ioctl header\n");
> >> --
> >> 1.7.7
> >>
> >>
> >
> > James seems to be uninterested in picking up
> > obvious and trivially correct patches.
> >
> 
> BTW: What about a checkpatch.pl rule to detect such a misuse of kmalloc()?
> We could grep for "k[mzc]alloc(GFP_".
> 
I like that idea. That's exactely how I find these; by doing 
egrep -R "[kv][mcz]alloc *\( *GFP_" 
on the source tree.
Might as well be in checkpatch.pl

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1676111565-1319497037=:19795--
