Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1AVPcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 10:32:50 -0500
Received: from smtp-out11.han.skanova.net ([195.67.226.200]:46891 "EHLO
	smtp-out11.han.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450Ab1AVPct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 10:32:49 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Jan 2011 10:32:48 EST
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 22 Jan 2011 16:26:40 +0100
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc1/-2: applesmc lockdep warning
Message-ID: <20110122152640.GA3232@polaris.bitmath.org>
References: <20110122134513.1e1d512a@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110122134513.1e1d512a@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

> since 2.6.38-rc1, the following shows up in dmesg.  Full dmesg is included
> below the signature.  This is a Macmini1,1 i.e. a first-generation
> Intel-based mini.  I haven't experienced any actual problem during usage
> but haven't used it a lot under 2.6.38-rc yet.
> 
> applesmc: key=137 fan=1 temp=7 acc=0 lux=0 kbd=0
> applesmc: init_smcreg() took 50 ms
> BUG: key f4891a1c not in .data!

Ouch. I will have to get back to this tonight, but my first reaction
is that the error message tells the truth, because the sysfs nodes are
now dynamically allocated during init. Perhaps sysfs_attr_init() is
missing or something.

Thanks!
Henrik
