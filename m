Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260Ab0KPLBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:01:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932806Ab0KPLBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:01:02 -0500
Date: Tue, 16 Nov 2010 12:01:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: gregkh@suse.de, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Aw: Re: [PATCH 0/3] HID: roccat: finishing usage of
 sysfs_create_bin_group()
In-Reply-To: <640538250.3216351289891020338.JavaMail.ngmail@webmail08.arcor-online.net>
Message-ID: <alpine.LNX.2.00.1011161159590.7420@pobox.suse.cz>
References: <alpine.LNX.2.00.1011152330540.7420@pobox.suse.cz> <1289853161.2188.44.camel@neuromancer> <20101115220828.GA9417@suse.de> <640538250.3216351289891020338.JavaMail.ngmail@webmail08.arcor-online.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Stefan Achatz wrote:

> > > > These patches are against the newest roccat file versions (after
> > > > applying everything I released the last days).
> > > > They fix some inattentive (though not critical) failures from previous
> > > > patches and change hid-roccat-koneplus and hid-roccat-pyra to use the
> > > > new sysfs_create_bin_group()
> > > > koneplus should be finished now (until I find errors)
> > > 
> > > Wait, they still don't resolve the main problem of this api is still
> > > racy and I can't accept it.
> > 
> > Yeah, I have already pointed Stefan to
> > 
> > 	 http://lkml.org/lkml/2010/11/13/174
> > 
> > which he might have missed.
> 
> Hello again,
> 
> I don't see why these patches can't be applied. The bin attribute group 
> functions standing for themself seem to be useful. The kone driver is 
> already in the stable kernel and has less code with these patches. 
> Though this does not change its functionality its a code cleanup. Thats 
> also true for pyra and koneplus. So for me these are clear improvements 
> until I make progress in the race problem. I will do it, but being a 
> newbe I don't know where to start (feel free to point me to something), 
> so it might take quite some time and sure needs some questions asked.

Hi Stefan,

the way the driver does things is racy and needs fixing. Introducing 
interface into sysfs/driver core, which we now know is racy, is not 
something we'd like to do.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
