Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1ATXYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:24:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55915 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1ATXYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:24:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fwx0eGcCiESujcTNs54LvAlz1RH8ahZ7dfKFABtdnDTqjjCO1iDmvo8qyPxbscxqxb
         lPppkL5ndVAUIaUa1PFXPqO0B2XwOulTkHInZjJDJ1U4qVYWyhs/Jq2feK80r+JRJItg
         ifYKt6irRyIDVPHrIOnXDAKSVNVPQJiqqRmX0=
Date: Fri, 21 Jan 2011 00:24:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>
Subject: Re: [BISECTED] agp/intel: revert "Remove confusion of stolen
 entries not stolen memory"
Message-ID: <20110120232410.GA19405@nowhere>
References: <201012201912.19051.arnd@arndb.de>
 <201012202047.08544.arnd@arndb.de>
 <0d30dc$kh3cm9@orsmga001.jf.intel.com>
 <201012202152.38863.arnd@arndb.de>
 <0d30dc$kh41r4@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d30dc$kh41r4@orsmga001.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 09:06:47PM +0000, Chris Wilson wrote:
> On Mon, 20 Dec 2010 21:52:38 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 20 December 2010 20:52:07 Chris Wilson wrote:
> > > 
> > > Also, which modules do you have loaded when using VESA? i.e. is the
> > > i915.ko loaded, but in UMS mode (i915.modeset=0)?
> > 
> > This doesn't seem to matter, as far as I can tell, i915 can be loaded
> > or now.
> 
> Thanks, that rules out the likely explanation that we [i915] loaded the
> GTT with some conflicting entries. Instead it is likely the initialisation
> of the GTT to point to the scratch page that is triggering the problem.
> Can you try disabling it with:

Hi,

I have the problem too with -rc1, and even with latest linus tree.

I too bisected back to:
"agp/intel: Remove confusion of stolen entries not stolen memory)"
(c64f7ba5f1006d8c20eacafecf98d4d00a6902a0)

Symptom is I see a big vertical cursor blinking in my screen and
nothing else. If something tries to be displayed it gets very messy.
