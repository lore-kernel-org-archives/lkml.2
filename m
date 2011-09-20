Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1ITHeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 03:34:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:5845 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab1ITHef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 03:34:35 -0400
Message-Id: <e39f63$1l0gme@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,410,1312182000"; 
   d="scan'208";a="55591630"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [BUG] i915 crashes X Server Constantly on Linux-3.1-rc4 to .rc6
To: Tarkan Erimer <tarkan.erimer@f-secure.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4E782C62.507@f-secure.com>
References: <4E770FF5.8030207@f-secure.com> <aefc95$1fgrb6@orsmga001.jf.intel.com> <4E773E65.5040809@f-secure.com> <aefc95$1fih8n@orsmga001.jf.intel.com> <4E782C62.507@f-secure.com>
Date: Tue, 20 Sep 2011 08:34:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011 09:02:10 +0300, Tarkan Erimer <tarkan.erimer@f-secure.com> wrote:
> On 09/19/2011 04:33 PM, Chris Wilson wrote:
> > That looks remarkably consistent. Can you please do a quick
> > addr2line -e /usr/lib64/xorg/modules/drivers/intel_drv.so 0x3e7ce 0x44d34
> >
> > Also do you know which particular site triggers the issue?
> > -Chris
> 
> Hi again Chris,
> 
> Here is the output as you requested :
> 
> linux-ou2v:~ # addr2line -e /usr/lib64/xorg/modules/drivers/intel_drv.so 
> 0x3e7ce 0x44d34
> ??:0
> ??:0
> linux-ou2v:~ #

Oops, no debugging symbols.
 
> At least, there is one particular website that always reproduces the 
> issue and it's :
> 
> http://www.instru.fi/piilolinssit

I've tried this on a few 32/64 bit machines (using different chips just
in case) on a few different distros. No instant death, I'll keep poking just
in case. Since flash is a sw rasteriser and uses ShmPutImage to update
its screen contents, these are typically an invalid memcpy. Having the
debug symbols would help confirm that and pinpoint which path.

Going back and checking your Xorg.log, I think you need this fix:

commit 3565c48c4bb77c836d817de75d098791dbb529d3
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Sep 14 17:45:41 2011 +0100

    sna: Yet another s/x/y/ typo
    
    Every time I do a transformation into pixmap space I like to include one
    of these copy'n'paste errors.
    
    Reported-by: Paul Neumann <paul104x@yahoo.de>
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=40850
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Hope this helps,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
