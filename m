Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0FYIOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 04:14:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60415 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab0FYIOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 04:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qAxO3U6bkePgDAVAxW0PlrFtjSqYJf9Aiqx5uGGTGYLa3DifwGRGVi+xNBJjEUHjOq
         f9HQsqeFuafyhwwOIXis2TXoKt+7A1G1erXeA1j3q1WBZyHH1nAwkg/N2wp3pVrjEPMd
         x4zbkEMaNEpHsP0WAk2aeLjGQb10snmYYMKZY=
Date: Fri, 25 Jun 2010 01:14:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH] input: evdev: Use multi-reader buffer to save space
 (rev5)
Message-ID: <20100625081445.GA8546@core.coreip.homeip.net>
References: <1277059734-2939-1-git-send-email-rydberg@euromail.se>
 <20100623061939.GB11187@core.coreip.homeip.net>
 <4C21C1C3.5050708@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C21C1C3.5050708@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 10:11:47AM +0200, Henrik Rydberg wrote:
> Dmitry Torokhov wrote:
> 
> > Overall I am starting getting concerned about proper isolation between
> > clients. Right now, if one client stops reading events and another one
> > issues grab then the first client will only get events that were
> > accumulated before grab tookm place. With the new shared buffer the
> > first client may get "grabbed" events if it stop for long enough for
> > buffer to wrap around.
> 
> Doing some research, the semantics of ioctl have obviously been discussed
> before, and I believe this points to another such issue. When grabbing a device,
> are we guaranteeing that the device no longer sends events to other clients, or
> are we guaranteeing that other clients can no longer read the device? If the
> latter, clearing all client buffers in conjunction with a grab would be
> appropriate, and would solve this issue.


Yes, I think it would be acceptable approach.

> 
> > Do we really same that much memory here? We normally do not have that
> > many users connected to event devices at once...
> 
> Ok, let's scratch this. Although I think the idea of multi-reader buffers is
> sound, it is obviously sufficiently incompatible with the current approach to
> produce distastefully complex patches. I will return with a new set which only
> fixes the buffer resize problem, and leaves the rest for later.
> 

Right, let's merge this and also MT slots and revisit this issue at some
later point.

Thanks.

-- 
Dmitry
