Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0I1XVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 19:21:07 -0400
Received: from trinity.fluff.org ([89.16.178.74]:37694 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab0I1XVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 19:21:04 -0400
Date: Wed, 29 Sep 2010 00:20:54 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: khali@linux-fr.org, mikpe@it.uu.se, rdunlap@xenotime.net,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH (Option 1)] of/i2c: fix module load order issue caused
	by of_i2c.c
Message-ID: <20100928232054.GQ21564@trinity.fluff.org>
References: <20100924221313.28357.61419.stgit@angua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924221313.28357.61419.stgit@angua>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 04:14:53PM -0600, Grant Likely wrote:
> Commit 959e85f7, "i2c: add OF-style registration and binding" caused a
> module dependency loop where of_i2c.c calls functions in i2c-core, and
> i2c-core calls of_i2c_register_devices() in of_i2c.  This means that
> when i2c support is built as a module when CONFIG_OF is set, then
> neither i2c_core nor of_i2c are able to be loaded.
> 
> This patch fixes the problem by moving the of_i2c_register_devices()
> function into the body of i2c_core and renaming it to
> i2c_scan_of_devices (of_i2c_register_devices is analogous to the
> existing i2c_scan_static_board_info function and so should be named
> similarly).  This function isn't called by any code outside of
> i2c_core, and it must always be present when CONFIG_OF is selected, so
> it makes sense to locate it there.  When CONFIG_OF is not selected,
> of_i2c_register_devices() becomes a no-op.

I sort of go with this one.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

