Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1ITQWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:22:14 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33810 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967Ab1ITQWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:22:12 -0400
X-Sasl-enc: Osrriz+9Khu8yDLOy1SX9oxUHNpIF/bjSfjZABrKje5y 1316535530
Date: Tue, 20 Sep 2011 09:15:50 -0700
From: Greg KH <greg@kroah.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: gregkh@suse.de, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@kernel.org>
Subject: Re: [patch 5/8] Platform: Fix error path in samsung-laptop init
Message-ID: <20110920161550.GA32194@kroah.com>
References: <20110901225401.GA26870@kroah.com>
 <20110901225331.122692921@clark.kroah.org>
 <CANq1E4TNagJzwLdUXTtR6ZGNJnbb6ppoP0-7mAoN7JUUTYpAVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4TNagJzwLdUXTtR6ZGNJnbb6ppoP0-7mAoN7JUUTYpAVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 02:21:54PM +0200, David Herrmann wrote:
> Hi Greg
> 
> On Fri, Sep 2, 2011 at 12:50 AM,  <gregkh@suse.de> wrote:
> > samsung_init() should not return success if not all devices are initialized.
> > Otherwise, samsung_exit() will dereference sdev NULL pointers and others.
> >
> > Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
> > Cc: stable <stable@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  drivers/platform/x86/samsung-laptop.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > --- a/drivers/platform/x86/samsung-laptop.c
> > +++ b/drivers/platform/x86/samsung-laptop.c
> > @@ -799,7 +799,7 @@ static int __init samsung_init(void)
> >        sabi_iface = ioremap_nocache(ifaceP, 16);
> >        if (!sabi_iface) {
> >                pr_err("Can't remap %x\n", ifaceP);
> > -               goto exit;
> > +               goto error_no_signature;
> >        }
> >        if (debug) {
> >                printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
> > @@ -851,7 +851,6 @@ static int __init samsung_init(void)
> >        if (retval)
> >                goto error_file_create;
> >
> > -exit:
> >        return 0;
> >
> >  error_file_create:
> >
> >
> >
> 
> "From: " line is missing in this patch and several others of this
> series. "git am" applies them with an email only so Matthew needs to
> fix them when applying them or you could just resend them with
> git-format-patch?

Crap I messed this up again, my mistake.  I'll go fix this up right now.
The original patch is correct, 'quilt mail' is the one that drops the
proper "From:" authorship on these messages when sending them out, which
is what I am using here.

I'll resend right now.

thanks,

greg k-h
