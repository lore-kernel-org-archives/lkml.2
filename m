Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab1DNOmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758881Ab1DNOmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:42:20 -0400
Date: Thu, 14 Apr 2011 10:42:09 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: dm: improve block integrity support
Message-ID: <20110414144208.GA26155@redhat.com>
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
 <alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6>
 <20110328230319.GA12790@redhat.com>
 <4D918347.7050500@fusionio.com>
 <20110329132032.GA22921@redhat.com>
 <yq1lizyhwlr.fsf@sermon.lab.mkp.net>
 <20110329135800.GB23508@redhat.com>
 <20110401174259.GA22598@redhat.com>
 <20110414140925.GA25803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414140925.GA25803@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14 2011 at 10:09am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> [trimming CCs so as not to pester as many people directly]
> 
> On Fri, Apr 01 2011 at  1:42pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > The current block integrity (DIF/DIX) support in DM is verifying that
> > all devices' integrity profiles match during DM device resume (which
> > is past the point of no return).  To some degree that is unavoidable
> > (stacked DM devices force this late checking).  But for most DM
> > devices (which aren't stacking on other DM devices) the ideal time to
> > verify all integrity profiles match is during table load.
> > 
> > Introduce the notion of an "initialized" integrity profile: a profile
> > that was blk_integrity_register()'d with a non-NULL 'blk_integrity'
> > template.  Add blk_integrity_is_initialized() to allow checking if a
> > profile was initialized.
> > 
> > Update DM integrity support to:
> > - check all devices with _initialized_ integrity profiles match
> >   during table load; uninitialized profiles (e.g. for underlying DM
> >   device(s) of a stacked DM device) are ignored.
> > - disallow a table load that would result in an integrity profile that
> >   conflicts with a DM device's existing (in-use) integrity profile
> > - avoid clearing an existing integrity profile
> > - validate all integrity profiles match during resume; but if they
> >   don't all we can do is report the mismatch (during resume we're past
> >   the point of no return)
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Hi Martin,
> 
> Any chance you've had a look at this?  I'm most interested in whether
> the code works with the various integrity profiles you have.
> 
> I'd really like to get this reviewed and queued for upstream so that it
> doesn't die on the vine.

Ah wow, just noticed this got in through the block tree over a week ago:
http://git.kernel.org/linus/a63a5cf84dac7a23a57

Thanks Jens!

Martin,
I've done enough testing that I am confident the DM integrity support is
in a better place with this change.  But I'd still really appreciate it
if you could verify all is well.

Mike
