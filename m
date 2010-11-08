Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0KHQ7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:59:04 -0500
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:35505 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754988Ab0KHQ7C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:59:02 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=1/Slja/RGsvbgQoKRcSayjT97G0g4FXdR74RvkxOJ8yVJL6hskEqTjnlmxH736szSbQVWRqxS8ip8tsfSkcxpBYBylqSop3C8ZZquRuIrDozpniecqr2d4O+a+9vriiYmvObajVZwOLnzbAyUlj+p0n56pYSx72pjbcYmXnhDEE=;
Message-ID: <99736.19751.qm@web31801.mail.mud.yahoo.com>
X-YMail-OSG: iU4.9oYVM1nBPYN_jOSHESTsIJQH49e.ucPUCxC9AVMVST2
 ZOFVd84W.iOwMolLzdYzjrTjKt9jjfAchCvjBYLhsgCepJdLuDQ5AUk0fLxb
 jB5SRlEj_TmYrdyGCJopqmoTwBIZ8mULn3drVoJXjgGih1LFhBNjn2RFx0c.
 aB4cPV.QN7xPvZL7mT8lI0YRBFInTJ.7T1u4yzo6nvCBqyR7u9ufFAsP.N4z
 gZiKN1hyR1RiT.D1BocSwdx6X5nDhpPE2VknLkT0Th5HW3qB_ds.tpk5wJHl
 MyQhUSegkVL5HLyhzs_IHIPq7_cut4o6INEpNydQlTAxurSH_k_VylZgIgWY
 lWfI2_cKP
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Mon, 8 Nov 2010 08:59:00 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20101108112131.GG4173@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 11/8/10, Matthew Wilcox <willy@linux.intel.com> wrote:
> On Wed, Oct 27, 2010 at 01:22:22PM
> -0700, Luben Tuikov wrote:
> > "Be conservative in what you send, liberal in what
> > you accept." -- In the spirit of this adage, don't
> > send Command IUs with randomly filled in data in
> > the reserved fields. (Yes, this shows up on the
> > wire.)
> 
> Applied, with a better changelog entry ...

"Better"? Where did you apply it? Your willy/uas.git doesn't show it (updated 3 months ago), neither do Greg's.

BTW, is it customary to change the change log?  What did you change? Do you mind sharing?

> > @@ -660,7 +660,7 @@ static int uas_probe(struct
> usb_interface *intf, const struct usb_device_id *id)
> >         
>     return -ENODEV;
> >      }
> >  
> > -    devinfo = kmalloc(sizeof(struct
> uas_dev_info), GFP_KERNEL);
> > +    devinfo = kzalloc(sizeof(struct
> uas_dev_info), GFP_KERNEL);
> >      if (!devinfo)
> >          return
> -ENOMEM;
> >  
> 
> Except for this hunk, which isn't an IU and doesn't go out
> on the wire.

Lol, no of course it doesn't, silly!

So help us understand: You've preserved all changes from kmalloc->kzalloc and left a single kmalloc alone. And your reason is that "*This* one doesn't go out on the wire?"

Wouldn't if have been more consistent (and harmless) to have changed all of them, just as the patch did?

