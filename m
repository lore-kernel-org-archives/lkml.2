Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab2APGOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 01:14:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:53983 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750728Ab2APGOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 01:14:42 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/P02QAnwXPM80g4bQuzoGJnWZoBFdYoh/yH6QSxk
	BHDm62eY4XwHHV
Subject: Re: Chronic resource starvation.
From: Mike Galbraith <efault@gmx.de>
To: Mike Mestnik <cheako@mikemestnik.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4F13B902.1090503@mikemestnik.net>
References: <4F10F3AE.3030801@mikemestnik.net>
	 <4F11E3B8.6090007@mikemestnik.net>
	 <1326629295.6352.14.camel@marge.simson.net>
	 <4F1322A6.7090009@mikemestnik.net>
	 <1326681574.6446.25.camel@marge.simson.net>
	 <4F13B902.1090503@mikemestnik.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 07:07:56 +0100
Message-ID: <1326694076.6446.166.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 23:43 -0600, Mike Mestnik wrote:

> Does fdatasync still cause this problem?  I'm sure there must be
> some way to 'group' applications together that should be allowed to
> avoid this effect and even insert IO requests during the operation if
> given a high enough priority.

And btw, that resource prioritization exists now for both CPU and IO
resources, look into cgroups and ionice for non-cgroup IO.  For the CPU
scheduler, you can automate task grouping by enabling SCHED_AUTOGROUP,
and some distros use a userland automation solution via systemd.  I
don't know if systemd does IO group automation, but groups won't help
defective spinning media anyway.

	-Mike

