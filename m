Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1EKPoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:44:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40744 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1EKPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Elg0Oa9nf+sh/sJ9r2ym2feecliXzKSFaW1eB0YZgGBBvbqbH9F+TNOGxbVX0sfGU0
         F2VGryEL+YmxcMGcIMG0cep/3dd1uvxbOWWiE2fWTYBuGdbbuLtmb1R0VxQxJyXdKW/q
         NMFPrw1r5g+Cf91si1ts5ZmLWTuXPVRw3GhtE=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Date: Wed, 11 May 2011 14:47:49 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r3; KDE/4.6.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <201104201358.50443.jasonbstubbs@gmail.com> <201104281855.50572.jasonbstubbs@gmail.com> <20110510223908.GA16989@kroah.com>
In-Reply-To: <20110510223908.GA16989@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105111447.49816.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 08:39:08 Greg KH wrote:
> On Thu, Apr 28, 2011 at 06:55:50PM +1000, Jason Stubbs wrote:
> > Not sure of the "bump" process, so I'll just go over each part of the
> > patch.
> > 
> > Note that all the changes only affect the sabi_config where
> > min_brightness is 1 so you might not see in difference on your hardware.
> 
> This isn't needed anymore due to your other patch superseeding it,
> right?

Actually, this one is irrelevant to the nc210/nc110 support as that laptop 
uses the "SwSmi@" sabi. It was just something I noticed while learning the 
code. The miscalculations will only affect any laptops that use the "SECLINUX" 
sabi but I tested it by setting min_brightness to 2 for my laptop.

The patch doesn't apply cleanly on top of the nc210/nc110 patch though as they 
both modify set_brightness(). It might apply with a higher fuzz factor as the 
changes don't actually clash. Should I redo the patch?

Regards,
Jason Stubbs
