Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1E3HLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 03:11:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:40958 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1E3HLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 03:11:20 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: david@lang.hm
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Date: Mon, 30 May 2011 09:13:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "D. Jansen" <d.g.jansen@googlemail.com>, Theodore Tso <tytso@mit.edu>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com> <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105300913.27971.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 30. Mai 2011, 03:53:18 schrieb david@lang.hm:
> > So what if we would queue the fsyncs along with the writes - we would
> > just fsync later instead of immediately, in between the writes as they
> > came in. Then by design previous data could not be corrupted, right?
> > We would do exactly the same thing, just later.
> > It'd be kind of a disk write time distortion field.
> 
> the problem is that the spec for fsync says that your program stops until 
> fsync finishes. If you don't do that then you will corrupt and loose data.

It is important to be precise.
You will loose data, but you will not get corruption.

> so if you delay fsync you will have your application (or desktop manager) 
> freeze until the fsync completes.
> 
> if what you are wanting is the ability to say 'these things must be 
> written before these other things to keep them from being corrupted, but I 
> don't care when they get written (or if they get lost in a crash)' then 
> what you want isn't fsync, it's a barrier.

Yes, but where is the problem?

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
