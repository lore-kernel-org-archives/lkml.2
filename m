Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1BTJKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 04:10:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33768 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1BTJKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 04:10:54 -0500
Date: Sun, 20 Feb 2011 09:10:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] msm: headsmp.S: Fix section mismatch
Message-ID: <20110220091020.GA14288@n2100.arm.linux.org.uk>
References: <1298085249-10518-1-git-send-email-sboyd@codeaurora.org> <1298168817.17118.2.camel@m0nster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298168817.17118.2.camel@m0nster>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 06:26:57PM -0800, Daniel Walker wrote:
> On Fri, 2011-02-18 at 19:14 -0800, Stephen Boyd wrote:
> > WARNING: vmlinux.o(.cpuinit.text+0xc80): Section mismatch in
> > reference from the function boot_secondary() to the variable
> > .init.text:msm_secondary_startup
> > The function __cpuinit boot_secondary() references a variable
> > __init msm_secondary_startup.  If msm_secondary_startup is only
> > used by boot_secondary then annotate msm_secondary_startup with
> > a matching annotation.
> 
> Description is pretty gross.. Can you just explain how the section
> mismatch is happening.

That's the error message, which is explanitory.

mem_secondary_startup is in the __init section, which is always discarded.
boot_secondary is in the __cpuinit section, which may or may not be
discarded, and if CPU hotplug is enabled, may be called after the __init
section has been discarded.
