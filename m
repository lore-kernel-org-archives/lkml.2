Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754Ab0FQVOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:14:12 -0400
Received: from mail.perches.com ([173.55.12.10]:1169 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab0FQVOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:14:11 -0400
Subject: Re: [PATCH] Staging: comedi: fix over 80 character coding style
 issues in ni_labpc.c
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Maurice Dawson <mauricedawson2699@gmail.com>, devel@driverdev.osuosl.org,
       gregkh@suse.de, stewart_r@aliencamel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100617203622.GB32523@kroah.com>
References: <1275123944-1886-1-git-send-email-mauricedawson2699@gmail.com>
	 <20100617203622.GB32523@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 14:14:08 -0700
Message-ID: <1276809248.1005.75.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 13:36 -0700, Greg KH wrote:
> On Sat, May 29, 2010 at 10:05:44AM +0100, Maurice Dawson wrote:
> > This is a patch to the ni_labpc.c file that fixes most over 80
> > character warnings found by the checkpatch.pl tool. Two lines, 4 and
> > 1035 have not been changed because readability is better and no
> > information is hidden
> > --- a/drivers/staging/comedi/drivers/ni_labpc.c
> > +++ b/drivers/staging/comedi/drivers/ni_labpc.c
> > @@ -738,7 +738,8 @@ static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
> >  		break;
> >  	case pcmcia_bustype:
> >  		printk
> > -		    (" this driver does not support pcmcia cards, use ni_labpc_cs.o\n");
> > +		    ("this driver does not support pcmcia cards, "
> > +							"use ni_labpc_cs.o\n");
> 
> Ick, no, don't break these types of strings.  Newer versions of
> checkpatch will not complain about this.

Hi Greg.

Unfortunately, currently checkpatch will complain about
this sort of line because the format string is not on the
same line as the printk.

This line should become something like:

		pr_err(" this driver does not support pcmcia cards, use ni_labpc_cs\n");
or
		comedi_err(etc...);

if ever the comedi_<level> printk helper macros are accepted.

