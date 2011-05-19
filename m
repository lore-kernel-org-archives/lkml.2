Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1ESDJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:09:24 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:47561 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932147Ab1ESDJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:09:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=sbBSH2DTjB/d3kRdcgXe/18TUt8L673TJwEVs9SwgRXOiJ0wzyCZ6Y9Z2vO3ZLhC;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Wed, 18 May 2011 23:09:18 -0400
From: Bill Fink <billfink@mindspring.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Decotigny <decot@google.com>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com
Subject: Re: [PATCH 1/2] forcedeth: make module parameters readable in
 /sys/module
Message-Id: <20110518230918.5c03ba68.billfink@mindspring.com>
In-Reply-To: <20110518150346.508d6406@nehalam>
References: <1305753000-14933-1-git-send-email-decot@google.com>
	<20110518150346.508d6406@nehalam>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d06a4fcaadc5c6f1a2384ff367c881fee350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.179.3.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011, Stephen Hemminger wrote:

> On Wed, 18 May 2011 14:09:59 -0700
> David Decotigny <decot@google.com> wrote:
> 
> > This change allows to publish the values of the module parameters in
> > /sys/module.
> 
> Although this makes more info for developer, it also means more
> stuff in sysfs taking more memory and not providing any real value
> that can't be found by looking at the /etc/modprobe.d for any parameters
> user might have set.

As a user, I find having the module parameter info in
/sys/module/driver/parameters/* extremely useful at times.
In tracking down weird problems I can for example do:

	grep . /sys/module/driver/parameters/*

to get a snapshot of module parameters.  I can then compare
this with other similar systems to see if there are any
differences of note that might be significant (anything
from differences due to kernel versions to just forgetting
some change I made).

I don't see that it's really much extra significant overhead
on the system either.

					-Bill
