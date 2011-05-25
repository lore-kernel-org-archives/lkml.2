Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1EYHqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:46:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab1EYHqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:46:20 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Date: Wed, 25 May 2011 08:50:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "D. Jansen" <d.g.jansen@googlemail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard>
In-Reply-To: <20110525000003.GJ32466@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105250850.12179.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 25. Mai 2011, 02:00:03 schrieb Dave Chinner:
> Oh, you're talking about application level write ordering. IO
> "ordering" in filesystem speak is about guaranteeing the order of
> data vs metadata writes for ensuring consistency after a crash
> (e.g. ext3/4 default "data=ordered" mode). that's what I was
> refering to, not anythign to do with applications.
> 
> Besides, having to work out how to handle subtle application write
> ordering bugs because you changed fsync semantics is simply another
> reason for not changing behaviour in the first place.

Sure. I'd say changing the behavior is right out. The question is whether
we want an additional "superlaptop"-mode.
And even in this case it seems to me that fsync() cannot be reduced to
a nop because of ordering constraints. But perhaps we should then consider
exporting an ordering primitive to user space.

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
