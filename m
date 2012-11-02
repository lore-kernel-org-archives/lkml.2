Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616Ab2KBXex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:34:53 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53304 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814Ab2KBXes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:34:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC] Suspend/resume without VT switches
Date: Sat, 03 Nov 2012 00:38:54 +0100
Message-ID: <2324361.keTRK1rkYL@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121102162937.1ec88cf1@jbarnes-desktop>
References: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org> <7608326.fQBj17U8Wv@vostro.rjw.lan> <20121102162937.1ec88cf1@jbarnes-desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 02, 2012 04:29:37 PM Jesse Barnes wrote:
> On Fri, 02 Nov 2012 22:51:07 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Friday, November 02, 2012 02:43:39 PM Jesse Barnes wrote:
> > > I've lightly tested this with X and it definitely makes my
> > > suspend/resume sequence a bit prettier.  It should speed things up
> > > trivally as well, but most of those gains come from other changes to the
> > > i915 driver (posted earlier to intel-gfx).
> > > 
> > > Any thoughts?
> > 
> > I like the idea.
> > 
> > > I suspect we'll have to be more defensive about the
> > > resume configuration in case the BIOS did something weird, but overall I
> > > think we should be able to do this one way or another.
> > 
> > Perhaps patch [1/2] should be [2/2] and vice versa? :-)
> 
> But then it wouldn't compile?  I added the variable first, defaulting
> to the current behavior, then made i915 support it and set the variable
> to false there...  At least, that's what I intended to do.

OK

So what happens if there are multiple graphics adapters in the system?
Including such that aren't handled by i915?  pm_vt_switch is global, so isn't
there any problem with that?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
