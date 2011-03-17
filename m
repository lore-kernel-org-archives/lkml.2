Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1CQIVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:21:30 -0400
Received: from linux-sh.org ([111.68.239.195]:52207 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1CQIV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:21:27 -0400
Date: Thu, 17 Mar 2011 17:20:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Kay Sievers <kay.sievers@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev class and sysdev
Message-ID: <20110317082016.GB13315@linux-sh.org>
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103131402.48129.rjw@sisk.pl> <201103131403.49561.rwys@fuw.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103131403.49561.rwys@fuw.edu.pl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 02:03:49PM +0100, R. J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Convert the SuperH clocks framework and shared interrupt handling
> code to using struct syscore_ops instead of a sysdev classes and
> sysdevs for power managment.
> 
> This reduces the code size significantly and simplifies it.  The
> optimizations causing things not to be restored after creating a
> hibernation image are removed, but they might lead to undesirable
> effects during resume from hibernation (e.g. the clocks would be left
> as the boot kernel set them, which might be not the same way as the
> hibernated kernel had seen them before the hibernation).
> 
> This also is necessary for removing sysdevs from the kernel entirely
> in the future.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

This misses the use of the sysdev class by the userimask code, though I'm
open to suggestions for alternatives.
