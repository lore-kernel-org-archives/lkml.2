Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0KDSdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:33:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:44600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab0KDSdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:33:42 -0400
Date: Thu, 4 Nov 2010 11:27:58 -0700
From: Greg KH <gregkh@suse.de>
To: Onkalo Samu <samu.p.onkalo@nokia.com>
Cc: "hmh@hmh.eng.br" <hmh@hmh.eng.br>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: device-core: sysfs open close notify
Message-ID: <20101104182758.GA19649@suse.de>
References: <1288861417-469-1-git-send-email-samu.p.onkalo@nokia.com> <20101104132339.GC10390@suse.de> <62697B07E9803846BC582181BD6FB6B836EB63CB54@NOK-EUMSG-02.mgdnok.nokia.com> <20101104160321.GB3631@suse.de> <1288888656.2072.5.camel@noppispoppis.nmp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288888656.2072.5.camel@noppispoppis.nmp.nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 06:37:36PM +0200, Onkalo Samu wrote:
> On Thu, 2010-11-04 at 17:03 +0100, ext Greg KH wrote:
> > On Thu, Nov 04, 2010 at 02:32:15PM +0100, samu.p.onkalo@nokia.com wrote:
> > > It is easy to get rid of if the mode parameter is used to pass the information
> > > that this entry uses open_close_notify.  What do you think, is it ok to use
> > > mode also to that purpose?
> > 
> > Don't try to overload a parameter that has been used for the past 40+
> > years in one way, to try to add additional side-band data that has
> > nothing to do with it.
> > 
> > That way lies madness.
> > 
> 
> And that is why I didn't even tried to do that in the first place - even
> if it would have been the simple way.
> 
> Is the implementation ok otherwise?
> 
> I'll add sysfs_create_file_notify which sets the control bit save way.
> I think it is enough if these entries can be done attribute by
> attribute. It is still possible delete them using normal sysfs
> operations.

No, don't do a separate file create because no one should ever create a
file on its own.  It should only be done by bus through a default
attribute, or, in extreem cases, done by purposefully controlling the
kobject uevents where you know exactly what you are doing.

Odds are, any user of this call wouldn't know exactly what they are
doing, so don't give them that opportunity to mess it up.

thanks,

greg k-h
