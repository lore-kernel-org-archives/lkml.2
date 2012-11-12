Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab2KLPaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 10:30:00 -0500
Received: from umail.aei.mpg.de ([194.94.224.6]:36596 "EHLO umail.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab2KLP37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:29:59 -0500
Date: Mon, 12 Nov 2012 16:29:57 +0100
From: Steffen Grunewald <Steffen.Grunewald@aei.mpg.de>
To: =?utf-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, htejun@gmail.com, tj@kernel.org,
        Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Subject: Re: Need assistance fixing a tg3 driver side-effect on IPMI
Message-ID: <20121112152957.GP30936@casco.aei.mpg.de>
References: <20121107082820.GP30936@casco.aei.mpg.de>
 <CAD9gYJ+2D6-Lu4L_CNEjsypd6WxhUzmkC1gY5STQSPp41p6J5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD9gYJ+2D6-Lu4L_CNEjsypd6WxhUzmkC1gY5STQSPp41p6J5Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 05:40:19PM +0800, 王金浦 wrote:
> Ferenc met samilar problem :
> 
> "Michael Chan" <mchan@broadcom.com> writes:
> 
> > On Tue, 2012-10-02 at 18:49 +0200, Ferenc Wagner wrote:
> >
> >> Going into the opposite direction: I found that Linux 3.6 does not
> >> permanently break the SoL console on upping eth0!  I'll try to find
> >> the commit which (sort of) fixed it.
> >
> > These are the likely fixes:
> >
> > commit cf9ecf4b631f649a964fa611f1a5e8874f2a76db
> > Author: Matt Carlson <mcarlson@broadcom.com>
> > Date: Mon Nov 28 09:41:03 2011 +0000
> >
> > tg3: Fix TSO CAP for 5704 devs w / ASF enabled
> 
> You are exactly right: cf9ecf4b fixed the premanent SoL breakage
> introduced by dabc5c67.  Looks like ASF utilizes similar technology to
> that of the HS20 BMC.  Thanks for the tip, it greatly reduced our CPU
> wear. :)  It's a pity ethtool -k did not give a hint.  Do you think it's
> possible to work around in 3.2 by eg. fiddling some ethtool setting?
> 
> the fix already go into Precise update to 3.2.31 stable release
> 
> So update your kernel should fix your problem.

Indeed, only a few days ago, 3.2.32 migrated into Wheezy - which cures
the problem.

Issue resolved (for now).

Thanks a lot to everyone,
 S

-- 
Steffen Grunewald * MPI Grav.Phys.(AEI) * Am Mühlenberg 1, D-14476 Potsdam
Cluster Admin * --------------------------------- * http://www.aei.mpg.de/
* e-mail: steffen.grunewald(*)aei.mpg.de * +49-331-567-{fon:7274,fax:7298}
