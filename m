Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0KRET3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 23:19:29 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:59966 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0KRET2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 23:19:28 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.41
X-Originating-IP: 80.4.117.127
Subject: Re: [RESEND] [PATCH] Input: add appleir USB driver
From: Bastien Nocera <hadess@hadess.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 18 Nov 2010 04:18:03 +0000
In-Reply-To: <20101008003940.GF31804@redhat.com>
References: <1285844276.26405.26.camel@cookie.hadess.net>
	 <201009300847.43090.dmitry.torokhov@gmail.com>
	 <1285861890.26405.37.camel@cookie.hadess.net>
	 <20101008003940.GF31804@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 2.91.2 (2.91.2-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1290053884.1435.10.camel@novo.hadess.net>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 20:39 -0400, Jarod Wilson wrote:
> On Thu, Sep 30, 2010 at 04:51:30PM +0100, Bastien Nocera wrote:
> > On Thu, 2010-09-30 at 08:47 -0700, Dmitry Torokhov wrote:
> > > Bastien,
> ...
> > >  I'll try
> > > to get the driver in .37 but after that we should probably move it
> > > over to the new IR infrastructure...
> > 
> > I'm not sure what that would bring us, nor do I have any experience in
> > using the ir-core. From what I understood, it still needed fleshing out.
> 
> There are a few things that still need fleshing out, but nothing really
> that should have any major impact on a potential port of this driver.
> 
> Off the top of my head, the main thing it would give you is the ability to
> upload your own keymap for the receiver.

You could already change the keymap...

>  Then someone wanting to use more
> than 6 buttons

But only for the 6 buttons supported.

>  or whatever it is might still be able to get the benefits
> of in-kernel decoding with everything coming through the input layer,
> rather than using lirc or the like.

I see very little benefits myself (I mean, unless you're adamant that
you want to use a remote that's not intended for that computer, but we
already have lirc user-space driver for doing that), and it would remove
metadata from the events, so we couldn't do "remote filtering" (each
remote has a semi-random UID, which gets passed in with the events).

When the appleir patch was finally accepted (which means I need to get
off my arse and do the changes Oliver mentioned), working on UID
filtering is next on my list of TODOs.

Cheers

