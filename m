Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1LMR0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 12:26:47 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:34703 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab1LMR0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 12:26:45 -0500
Date: Tue, 13 Dec 2011 12:26:42 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: REGRESSION: v3.2-rcX: iwlagn refuses to associate with my AP's
Message-ID: <20111213172642.GA4962@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
References: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 02:42:53PM -0500, Theodore Ts'o wrote:
> Hi there,
> 
> I recently discovered a regression in the iwlagn driver (works in v3.1
> but not in v3.2-rc2... I'm going to continue to bisect, but I thought
> I'd give a heads up now).  I'm using a Lenovo T410, with the following
> wireless card:
> 
> [   11.197410] iwlwifi 0000:03:00.0: HW Revision ID = 0x35
> [   11.197637] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N + WiMAX 6250 AGN, REV=0x84
> 
> The failure to associate with access points happens at work, with
> whatever AP's are in use at the Cambridge Google office.  When I tried
> v3.2-rc5 at home, I was able to associate with a consumer-grade NetGear
> AP, although it was flaky --- that is, it completely failed to associate
> initially, but then I tried rebooting and I was eventually able to get
> it to work.   At work, I was able to reproduce the problem with a
> v3.2-rc5 and v3.2-rc2 kernel, but the problem did not manifest itself
> with a v3.1 kernel.

OK, a follow up.  A bisection puts the finger of blame very firmly at:

debcf73 iwlagn: handle GO powersave

Specifically, I can't associate with *any* access points (encrypted or
not) if I compile a kernel at commit debcf73, but if I compile a
kernel with its parent (commit 8ad71be), it works fine.

However, as a puzzler, when I tried reverted compiling 3.2-rc5 with
debcf73 reverted, it did not make the problem go away.  So there's
something more going on here.  I could try doing a bisect with reverts
of debcf73 at each step, trying to find the problem, but I'm hoping
this is enough of a hint that someone can tell me either that this is
fixed already in the linux-wireless tree, or that they know what's
wrong and can provide a test patch...

Thanks,

						- Ted
