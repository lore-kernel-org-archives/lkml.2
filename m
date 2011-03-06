Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab1CFOio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 09:38:44 -0500
Received: from ist.d-labs.de ([213.239.218.44]:40899 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559Ab1CFOim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 09:38:42 -0500
Date: Sun, 6 Mar 2011 15:38:05 +0100
From: Florian Mickler <florian@mickler.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] [media] dib0700: get rid of on-stack dma buffers
Message-ID: <20110306153805.001011a9@schatten.dmk.lab>
In-Reply-To: <201103061306.10045.oliver@neukum.org>
References: <1299410212-24897-1-git-send-email-florian@mickler.org>
	<201103061306.10045.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011 13:06:09 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> Am Sonntag, 6. März 2011, 12:16:52 schrieb Florian Mickler:
> > This should fix warnings seen by some:
> > 	WARNING: at lib/dma-debug.c:866 check_for_stack
> > 
> > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=15977.
> > Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> > CC: Mauro Carvalho Chehab <mchehab@infradead.org>
> > CC: linux-media@vger.kernel.org
> > CC: linux-kernel@vger.kernel.org
> > CC: Greg Kroah-Hartman <greg@kroah.com>
> > CC: Rafael J. Wysocki <rjw@sisk.pl>
> > CC: Maciej Rutecki <maciej.rutecki@gmail.com>
> > ---
> > 
> > Please take a look at it, as I do not do that much kernel hacking
> > and don't wanna brake anybodys computer... :)
> > 
> > From my point of view this should _not_ go to stable even though it would
> > be applicable. But if someone feels strongly about that and can
> > take responsibility for that change...
> 
> The patch looks good and is needed in stable.
> It could be improved by using a buffer allocated once in the places
> you hold a mutex anyway.
> 
> 	Regards
> 		Oliver

Ok, I now put a buffer member in the priv dib0700_state which gets
allocated on the heap. 

My patch introduces a new error condition in the dib0700_identify_state
callback which gets not checked for in dvb_usb_find_device... 
Should we worry?

Same for dib0700_get_version in the probe callback...
But there, there was already the possibility of usb_control_msg
returning an error...

Regards,
Flo
