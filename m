Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561Ab0KRVLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:11:50 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12093 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760486Ab0KRVLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:11:49 -0500
Date: Thu, 18 Nov 2010 21:59:07 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Russell King <rmk@arm.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Anderson <andmike@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer derefs
 in scsi_error.c and reduce size as well
In-Reply-To: <20101118210642.GA24236@flint.arm.linux.org.uk>
Message-ID: <alpine.LNX.2.00.1011182158270.11697@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net> <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com> <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net> <20101118210642.GA24236@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Russell King wrote:

> On Thu, Nov 18, 2010 at 09:49:29PM +0100, Jesper Juhl wrote:
> > @@ -617,10 +623,10 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
> >  
> >  static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
> >  {
> > -	if (!scmd->device->host->hostt->eh_abort_handler)
> > -		return FAILED;
> > -
> > -	return scmd->device->host->hostt->eh_abort_handler(scmd);
> > +    struct scsi_host_template *hostt = scmd->device->host->hostt;
> > +    if (!hostt->eh_abort_handler)
> > +        return FAILED;
> > +    return hostt->eh_abort_handler(scmd);
> 
> Not that I have much to do with SCSI anymore... I spotted the above.
> Is there any particular reason for using spaces to indent here rather
> than our usual tabs?
> 
No. That was me and Emacs having a slight disagreement (see the mail I 
just sent)...

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

