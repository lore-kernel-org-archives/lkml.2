Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab1DSWcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 18:32:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab1DSWcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 18:32:09 -0400
Subject: Re: 2.6.39-rc1 nouveau(?) regression (bisected)
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kyle Spaans <kspaans@uwaterloo.ca>, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, mjg@redhat.com,
        maciej.rutecki@gmail.com, nouveau@lists.freedesktop.org,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        Nick Piggin <npiggin@gmail.com>
In-Reply-To: <20110419214747.GA2965@joi.lan>
References: <20110414190117.GA3493@joi.lan>
	 <20110415061136.GA21979@isilmar-3.linta.de>
	 <4DAA1453.5000604@nigelcunningham.com.au>
	 <20110416235028.GA6096@taurine.csclub.uwaterloo.ca>
	 <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
	 <20110417154557.GA2871@joi.lan>
	 <20110417162427.GB25242@taurine.csclub.uwaterloo.ca>
	 <20110417164920.GA2626@joi.lan> <20110418200204.GA2522@joi.lan>
	 <BANLkTi=Oo03CQchHYh4EvEsk+wZy7akLNw@mail.gmail.com>
	 <20110419214747.GA2965@joi.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 08:34:42 +1000
Message-ID: <1303252482.7270.398.camel@caspar>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 23:47 +0200, Marcin Slusarz wrote:
> On Mon, Apr 18, 2011 at 01:27:10PM -0700, Linus Torvalds wrote:
> > On Mon, Apr 18, 2011 at 1:02 PM, Marcin Slusarz
> > <marcin.slusarz@gmail.com> wrote:
> > >
> > > It's some nasty corruption:
> > 
> > Looks like something wrote 0xffffffff to free'd memory.
> > 
> > Enabling DEBUG_PAGEALLOC *might* show where it happens.
> > 
> > >
> > > [    6.523867] =============================================================================
> > > [    6.523916] BUG sysfs_dir_cache: Poison overwritten
> > > [    6.523949] -----------------------------------------------------------------------------
> > > [    6.523950]
> > > [    6.524016] INFO: 0xffff8801bb47df4c-0xffff8801bb47df4f. First byte 0xff instead of 0x6b
> > > [    6.524061] INFO: Slab 0xffffea00060f7b58 objects=22 used=21 fp=0xffff8801bb47df18 flags=0x80000000000000c1
> > > [    6.524110] INFO: Object 0xffff8801bb47df18 @offset=3864 fp=0x          (null)
> > > [    6.524111]
> > > [    6.524170] Bytes b4 0xffff8801bb47df08:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
> > > [    6.524516]   Object 0xffff8801bb47df18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > > [    6.524862]   Object 0xffff8801bb47df28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > > [    6.525208]   Object 0xffff8801bb47df38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > > [    6.525556]   Object 0xffff8801bb47df48:  6b 6b 6b 6b ff ff ff ff 6b 6b 6b 6b 6b 6b 6b 6b kkkk<FF><FF><FF><FF>kkkkkkkk
> > 
> > So here the 0xffffffff is pretty obvious.
> > 
> > > and in another boot:
> > >
> > > [    6.704786] BUG: unable to handle kernel paging request at ffffffffbc70b058
> > 
> > Here it is less obvious, but it was _probably_ a regular kernel
> > pointer of the type 0xffff8801bc70b058 before the high bits were
> > overwritten by a 0xffffffff.
> > 
> > So then sysfs_refresh_inode() follows that pointer, and crashes.
> > 
> > Just a guess, obviously, but it looks rather likely.
> 
> Thanks. It helped a bit.
> I'll send two patches in response to this message, one of which fixes this bug.
Nice catch.  I'll push these to the nouveau tree now, and get them to
Dave with some additional fixes.

Ben.
> 
> Marcin
> 


