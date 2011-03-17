Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1CQNr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 09:47:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1CQNrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 09:47:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: IIO comments
Date: Thu, 17 Mar 2011 14:47:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
References: <201103152215.20059.arnd@arndb.de> <201103161433.31303.arnd@arndb.de> <4D80CE2E.9000407@cam.ac.uk>
In-Reply-To: <4D80CE2E.9000407@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103171447.17960.arnd@arndb.de>
X-Provags-ID: V02:K0:HmW73OFKGDNQtzKCJt/0mz53fSKvJkiMqXgGJs2neDy
 3yVdUVtkaPt+CIapI3QDsD+/vDjV3aClWl2duUSGDTvWujApiH
 FNbyoWjuTvIcke0kYbAD3JqT54xtK0OAntJGtHfvyqpfOQWc0B
 B6pwL3ADU07zy9aYemNSVbcsnINsjid4+SI/dAAVuF6pmUx54a
 bf9OAJQoflk5IM6eL0G7A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just went back to the older email and noticed that I missed some of your
important replies.

On Wednesday 16 March 2011, Jonathan Cameron wrote:
> > I'm slightly confused, mainly because I have no idea how the
> > buffer and event interfaces are actually being used. I would
> > have expected an interface as simple as:
> > 
> > * One iio device per sensor that can provide data, possibly
> >   many per hardware device
>
> One per device.

I'm not sure what that means. One iio device per hardware device?

What about hardware devices that have multiple unrelated streams
of buffered input data?

> > * One chardev for each iio device
>
> currently 1-3. (event line, buffer access, buffer event)

It would be really nice to unify this, as I said. What
are the reasons why you think it cannot or should not be
done?

> > * Use epoll to wait for data and/or out-of-band messages
> > * Use chrdev read to get events from the buffer
>
> and data?

I mean get the data associated with the event. The event
itself as you said does not have any data, so we would not
need to read it, just to use poll()/epoll() in order to
wait for it.

> > * Use sysfs to read from sensors that are not event based
> > 
> > What you have is obviously more complex than this, and you
> > probably have good reasons that I still need to understand.

	Arnd
