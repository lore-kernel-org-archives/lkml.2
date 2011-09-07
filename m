Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1IGUBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:01:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43356 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab1IGUBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:01:04 -0400
Subject: Re: [PATCH] random: add blocking facility to urandom
From: Sasha Levin <levinsasha928@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4E67C659.1080707@redhat.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <1315417137-12093-1-git-send-email-jarod@redhat.com>
	 <1315419179.3576.6.camel@lappy>  <4E67B75B.8010500@redhat.com>
	 <1315422330.3576.22.camel@lappy>  <4E67C659.1080707@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 07 Sep 2011 23:00:42 +0300
Message-ID: <1315425642.3576.30.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 15:30 -0400, Jarod Wilson wrote:
> Sasha Levin wrote:
> > On Wed, 2011-09-07 at 14:26 -0400, Jarod Wilson wrote:
> >> Sasha Levin wrote:
> >> [..] And anything done in
> >> userspace is going to be full of possible holes [..]
> >
> > Such as? Is there an example of a case which can't be handled in
> > userspace?
> 
> How do you mandate preventing reads from urandom when there isn't 
> sufficient entropy? You likely wind up needing to restrict access to the 
> actual urandom via permissions and selinux policy or similar, and then 
> run a daemon or something that provides a pseudo-urandom that brokers 
> access to the real urandom. Get the permissions or policy wrong, and 
> havoc ensues. An issue with the initscript or udev rule to hide the real 
> urandom, and things can fall down. Its a whole lot more fragile than 
> this approach, and a lot more involved in setting it up.

Replace /dev/urandom with a simple CUSE driver, redirect reads to the
real urandom after applying your threshold.

-- 

Sasha.

