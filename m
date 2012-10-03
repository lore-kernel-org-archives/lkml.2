Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab2JCTvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:51:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38517 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698Ab2JCTvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:51:01 -0400
X-Sasl-enc: 0443S6Rthl9RPYuq4ZXWbZHPQKaBU3MehzqvUqTCFhdr 1349293860
Date: Wed, 3 Oct 2012 12:50:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121003195059.GA13541@kroah.com>
References: <4FE9169D.5020300@redhat.com>
 <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com>
 <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com>
 <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk>
 <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 10:32:08AM -0700, Linus Torvalds wrote:
> On Wed, Oct 3, 2012 at 10:09 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > +       if (!S_ISREG(inode->i_mode))
> > +               return false;
> > +       size = i_size_read(inode);
> >
> > Probably better to do vfs_getattr() and check mode and size in kstat; if
> > it's sufficiently hot for that to hurt, we are fucked anyway.
> >
> > +               file = filp_open(path, O_RDONLY, 0);
> > +               if (IS_ERR(file))
> > +                       continue;
> > +printk("from file '%s' ", path);
> > +               success = fw_read_file_contents(file, fw);
> > +               filp_close(file, NULL);
> >
> > fput(file), please.  We have enough misuses of filp_close() as it is...
> 
> Ok, like this?

This looks good to me.  Having udev do firmware loading and tieing it to
the driver model may have not been such a good idea so many years ago.
Doing it this way makes more sense.

greg k-h
