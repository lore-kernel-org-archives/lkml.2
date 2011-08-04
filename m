Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1HDXnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:43:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1HDXnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:43:49 -0400
Date: Thu, 4 Aug 2011 16:42:55 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devtmpfs: Fix section mismatch on devtmpfsd()
Message-ID: <20110804234255.GA19764@suse.de>
References: <1312497371-25685-1-git-send-email-grant.likely@secretlab.ca>
 <20110804225418.GA2505@suse.de>
 <CACxGe6sQ2hQr4XTZ72mU-jMv1G4xO_NHp54L_c04L08pscaG9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6sQ2hQr4XTZ72mU-jMv1G4xO_NHp54L_c04L08pscaG9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 12:32:15AM +0100, Grant Likely wrote:
> On Thu, Aug 4, 2011 at 11:54 PM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Aug 04, 2011 at 11:36:11PM +0100, Grant Likely wrote:
> >> devtmpfsd_init() references setup_done which is __initdata, but
> >> devtmpfsd() is not an __init function.  The code is fine, because it
> >> is never referenced after discarding __init sections, but it leaves
> >> some additional code that can be discarded with the rest of __init and
> >> it causes gcc to complain with a section mismatch warning.
> >
> > I have a simpler patch here that just removes the __initdata function,
> > which is simpler.
> >
> > I hate the initdata stuff, it's almost always pointless...
> 
> initdata I don't mind.  Discarding stuff that is no longer necessary
> isn't a bad thing and I don't find it that onerous.  __devinit* seems
> less useful since I've never worked on a system that can actually
> discard it.

Yes, that's the one I really want to get rid of.  One of these days on a
long flight I'll work up a series of patches to drop it...

thanks,

greg k-h
