Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1CWJq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:46:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41651 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1CWJq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:46:26 -0400
Date: Wed, 23 Mar 2011 09:45:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kay Sievers <kay.sievers@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Mundt <lethal@linux-sh.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 9/10] sh: Use struct syscore_ops instead of sysdev
	class and sysdev
Message-ID: <20110323094557.GA3040@n2100.arm.linux.org.uk>
References: <201103100131.58206.rjw@sisk.pl> <20110322214922.GA7503@linux-sh.org> <1300831256.1815.22.camel@zag> <201103222323.42627.rjw@sisk.pl> <1300833843.1815.53.camel@zag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300833843.1815.53.camel@zag>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:44:03PM +0100, Kay Sievers wrote:
> When we started to clean up /sys (again only talking about devices, not
> other stuff) we had:
>   /block/*
>   /class/<subsys>/*
>   /bus/<subsys>/devices/*
>   /devices/system/<subsys>/*
> which are 4 different exports of exactly the same thing, a "device".
> "Block" we converted to "class" already, "class" will be converted to
> "bus", and "bus" will be renamed to "subsystem". All the current names
> will be kept as compat symlinks, just as we did for "block".

I bet userspace will end up failing with that and need updating yet
again, inspite of the symlinks.

While Linus complains about the churn in the ARM subtree, I'd like to
officially complain about the pointless churn in sysfs which actively
breaks (and sometimes prevents) userspace booting when you upgrade
kernels.
