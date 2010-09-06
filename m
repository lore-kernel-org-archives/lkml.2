Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0IFA3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:29:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:36975 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab0IFA3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:29:35 -0400
Date: Mon, 6 Sep 2010 10:29:32 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: apparmor: double lock
In-Reply-To: <4C832DA6.8070707@canonical.com>
Message-ID: <alpine.LRH.2.00.1009061029170.9229@tundra.namei.org>
References: <4C823419.6050906@gmail.com> <4C832DA6.8070707@canonical.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Sep 2010, John Johansen wrote:

> On 09/04/2010 04:57 AM, Jiri Slaby wrote:
> > Hi,
> > 
> > stanse found that you possibly double lock ns->lock:
> > aa_remove_profiles
> >   -> write_lock(&ns->lock)
> >   -> __remove_namespace(ns)
> >     -> destroy_namespace(ns)
> >       -> write_lock(&ns->lock)
> > 
> > Could you fix that if that may happen at all?
> > 
> Yes, thanks Jiri, the patch has already been posted
> 
> http://marc.info/?l=linux-kernel&m=128295924407596&w=2

Are all of the patches in that set ready to be merged to Linus?

-- 
James Morris
<jmorris@namei.org>
