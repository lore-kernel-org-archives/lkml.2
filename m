Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0KHRuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 12:50:18 -0500
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:46981 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753060Ab0KHRuQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 12:50:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=OBBfvYgYRH9vne3pj4t0nsOqgRfDwDqQNo3JvUnO8dPGMqYdYdI+x10OTf5eB9+zSGS4HEPCAielgBfhLrxJDHwZVOcT8IpStE86/dsaS1+drll+wvpGlNX6+ICxNDHDsb2dVZCBlyL1TD19oUD9q5EVLZFFcoTj5mI6yxDT1qc=;
Message-ID: <549309.47855.qm@web31801.mail.mud.yahoo.com>
X-YMail-OSG: xmvcl80VM1ncc9V7xl1X.3vqbxETuA36bChXzMFfdub0l70
 WNl7jJIzsrzUVlRzP3DgPzGjvKBPpvgtUX6djHrDFTmplfCY6J7mKm1IenWy
 mtfE7D0fbmcf2X7DxWPtD9T.8RZGvXXe0Khp6NUIQC_13AIU9c2cvJc4Oekw
 QN2Ito_1N.ukmFi4oQsHj6GYegoRH9EpvkrOcwNdyoCHw8wVyU9NvYGXgSpF
 PHZ8rh2GnR3cj1feasdgmIzxcHx8Zho9OQ4gTybxWFEhzbV0e0Xnd_rQiQaH
 dWvFr4fFrToRtWG6LxSGcm3ibOOHRec7EcmYB3ghwm2KCiJ.4eiIdMyUqfWD
 6_OdzSxZp378Iur1dLxcXgww4zjcPmjgI9A--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Mon, 8 Nov 2010 09:50:15 -0800 (PST)
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
> --- On Mon, 11/8/10, Matthew Wilcox
> <willy@linux.intel.com>
> wrote:
> > On Wed, Oct 27, 2010 at 01:22:22PM
> > -0700, Luben Tuikov wrote:
> > > "Be conservative in what you send, liberal in
> what
> > > you accept." -- In the spirit of this adage,
> don't
> > > send Command IUs with randomly filled in data in
> > > the reserved fields. (Yes, this shows up on the
> > > wire.)
> > 
> > Applied, with a better changelog entry ...
> 
> "Better"? Where did you apply it? Your willy/uas.git
> doesn't show it (updated 3 months ago), neither do Greg's.
> 
> BTW, is it customary to change the change log?  What
> did you change? Do you mind sharing?

Matthew, could you reply-all here with your new, changed and
modified change log?

I'd like you to be accountable to what and how you've changed the changelog HERE and not in a git three somewhere and have an open comparison to what your new change log is and what is says.

Mine, quoted above:
  a) mentions an adage that's been around for 30 years at least,
     in the UNIX/net field to which we adhere.
  b) mentions (only!) the Command IU of making out on the wire
     with stale system data of the memory used for it.

Could you please reconsider your professional integrity and
submit the patch as is with the original log?

> > > @@ -660,7 +660,7 @@ static int uas_probe(struct
> > usb_interface *intf, const struct usb_device_id *id)
> > >         
> >     return -ENODEV;
> > >      }
> > >  
> > > -    devinfo = kmalloc(sizeof(struct
> > uas_dev_info), GFP_KERNEL);
> > > +    devinfo = kzalloc(sizeof(struct
> > uas_dev_info), GFP_KERNEL);
> > >      if (!devinfo)
> > >          return
> > -ENOMEM;
> > >  
> > 
> > Except for this hunk, which isn't an IU and doesn't go
> out
> > on the wire.
> 
> Lol, no of course it doesn't, silly!

And notice that /my/ change log doesn't claim that 
uas_dev_info makes it out the wire. It only mentions that
the Command IU makes it out the wire with stale data.

> 
> So help us understand: You've preserved all changes from
> kmalloc->kzalloc and left a single kmalloc alone. And
> your reason is that "*This* one doesn't go out on the
> wire?"
> 
> Wouldn't if have been more consistent (and harmless) to
> have changed all of them, just as the patch did?
> 
> 
