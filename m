Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0KHSqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:46:20 -0500
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:26073 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754936Ab0KHSqT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:46:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=gjw14LeosLi9EB7vCGIVmvCSu0dURIy61LnLplo2AV+VgNGuTvsFaP29hJQYSv9dAYivd7KqCWtt/hl15kBWcJvLqvkN3xldn5dgYCjpCdoigyjld4ax88Anag5cMck5ito4O+Ijnb2HxQS2ig8OjNTOiAgMwJlY89Zrz3eNb2Q=;
Message-ID: <532497.95375.qm@web31810.mail.mud.yahoo.com>
X-YMail-OSG: vSTe8pgVM1kYu7tNNH046AbpHKbH9tISO3xY59Tt6F70EWc
 Fno9DFhrx8aXvX0i18PNQJsbD8IUEOaX8Ajd_FMyeHdR8rNeaRHnqhcHlyfg
 eFP90TyGUHkTBIMULS6cTKDqor9NpsDojTq7MSia57eBCe_3L.em4.FLqUUC
 pL0YSymRWRkgHOrgk57U2AreQpLshbyr8DrT_zBuRsBGmeiHN21jUmMgpV.V
 Dk13cVBjeswS7eF2qqXO7uIS_GVe9aWm44frZckFmqEe1HLEP0PGSAyVU_z.
 Ei_T7Q__jygz4CeeFJOwqtrPrEzJb5xQWq8Ld2caLuX9fWVFuB4RoqDd.tBA
 0jkHgjMbK8XKHlvL5wSP2mXvaByJpMCAKeEM-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Mon, 8 Nov 2010 10:46:18 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 11/8/10, Luben Tuikov <ltuikov@yahoo.com> wrote:
> --- On Mon, 11/8/10, Luben Tuikov
> <ltuikov@yahoo.com>
> wrote:
> > --- On Mon, 11/8/10, Matthew Wilcox
> > <willy@linux.intel.com>
> > wrote:
> > > On Wed, Oct 27, 2010 at 01:22:22PM
> > > -0700, Luben Tuikov wrote:
> > > > "Be conservative in what you send, liberal
> in
> > what
> > > > you accept." -- In the spirit of this
> adage,
> > don't
> > > > send Command IUs with randomly filled in
> data in
> > > > the reserved fields. (Yes, this shows up on
> the
> > > > wire.)
> > > 
> > > Applied, with a better changelog entry ...
> > 
> > "Better"? Where did you apply it? Your willy/uas.git
> > doesn't show it (updated 3 months ago), neither do
> Greg's.
> > 
> > BTW, is it customary to change the change log?  What
> > did you change? Do you mind sharing?
> 
> Matthew, could you reply-all here with your new, changed
> and
> modified change log?
> 
> I'd like you to be accountable to what and how you've
> changed the changelog HERE and not in a git three somewhere
> and have an open comparison to what your new change log is
> and what is says.
> 
> Mine, quoted above:
>   a) mentions an adage that's been around for 30 years
> at least,
>      in the UNIX/net field to which we
> adhere.
>   b) mentions (only!) the Command IU of making out on
> the wire
>      with stale system data of the
> memory used for it.
> 
> Could you please reconsider your professional integrity
> and
> submit the patch as is with the original log?

Matthew,

I did NOT Signed-off-by: with my name and email to a patch where you've changed both the change log and the diff.

Now, you have two options here:

a) commit the modified by you patches, {change log and diff}, AS YOUR OWN patches, removing the Signed-off-by: me line, OR

b) commit the patch, {change log and diff}, as I've posted it, thus preserving the Signed-off-by: me line.

A Signed-off-by: line is a digital signature, and we cannot have that under text (the change log) that that person didn't write or agree to.

I don't mind either a) or b), but if a) then we need to include this practice of changing the patch {change log and diff} by the maintainer and removing the Signed-off-by: line of the author of the patch in Documentation/development-process/ so that contributors to the kernel are aware of this practice.

> 
> > > > @@ -660,7 +660,7 @@ static int
> uas_probe(struct
> > > usb_interface *intf, const struct usb_device_id
> *id)
> > > >         
> > >     return -ENODEV;
> > > >      }
> > > >  
> > > > -    devinfo = kmalloc(sizeof(struct
> > > uas_dev_info), GFP_KERNEL);
> > > > +    devinfo = kzalloc(sizeof(struct
> > > uas_dev_info), GFP_KERNEL);
> > > >      if (!devinfo)
> > > >          return
> > > -ENOMEM;
> > > >  
> > > 
> > > Except for this hunk, which isn't an IU and
> doesn't go
> > out
> > > on the wire.
> > 
> > Lol, no of course it doesn't, silly!
> 
> And notice that /my/ change log doesn't claim that 
> uas_dev_info makes it out the wire. It only mentions that
> the Command IU makes it out the wire with stale data.
> 
> > 
> > So help us understand: You've preserved all changes
> from
> > kmalloc->kzalloc and left a single kmalloc alone.
> And
> > your reason is that "*This* one doesn't go out on the
> > wire?"
> > 
> > Wouldn't if have been more consistent (and harmless)
> to
> > have changed all of them, just as the patch did?
> > 
> >
> 
