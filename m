Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0JEP4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:56:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33568 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036Ab0JEP4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ieWX64N8uDTngqjkYJDm6qP1Gv40/DUG8mia7GGQeGFn7XOgpU9L+b1KYUvKo9PJRm
         scivkev94mZPsYm3qX3XX4XL0hAl+4j4ks8R9dbreC+4Pv8vKhZ6+AgHWHjqDx4DWajG
         Lg16ANYbmMtKKqif6Ole7HMKb55s2AGmKssAA=
Date: Tue, 5 Oct 2010 08:55:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Bastien Nocera <hadess@hadess.net>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] [PATCH] Input: add appleir USB driver
Message-ID: <20101005155552.GB19730@core.coreip.homeip.net>
References: <1285844276.26405.26.camel@cookie.hadess.net>
 <201010050802.14271.oliver@neukum.org>
 <20101005060822.GD15355@core.coreip.homeip.net>
 <201010050818.35118.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010050818.35118.oliver@neukum.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 08:18:35AM +0200, Oliver Neukum wrote:
> Am Dienstag, 5. Oktober 2010, 08:08:22 schrieb Dmitry Torokhov:
> > > But what about the next opener? He'll get a completely spurious
> > > key release event, as the next key is pressed.
> > 
> > How does the opening of a device handle relate to a device state?
> 
> It doesn't.
> 
> > Userspace should expect to see releases without presses (in case they
> > weren't the first client that opened the device).
> 
> Yes, but based on sane timing. From the time stamps user space
> would conclude that the key had been pressed at an unknown time
> before open and released at the time the event indicates. Possibly
> it would compute that the key had been held for at least hours.
> 

I do not understand. If a client never seen the "press" event and only
saw "release" event it can't make any assumptions about timing. Press
could be a millisecond ago or an hour ago, it just does not know. And
such scenario can easily happen if the client is second to open the
device.

I think the only sane behavior for clients is to ignore release events
for keys that they did not see "down" event for.

- 
Dmitry
