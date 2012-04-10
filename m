Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab2DJCZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 22:25:58 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:48325 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2DJCZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 22:25:57 -0400
Message-ID: <1334024754.2103.9.camel@shrek.rexursive.com>
Subject: Re: [PATCH v8]: Hibernation: lower/better control the amount of
 pages used for buffering
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        Per Olofsson <pelle@debian.org>
Date: Tue, 10 Apr 2012 12:25:54 +1000
In-Reply-To: <2cbc3801-3ab0-4ef6-84cd-d69a23ff4dcc@email.android.com>
References: <1333418527.2035.11.camel@shrek.rexursive.com>
	 <201204030631.24974.rjw@sisk.pl>
	 <1333432393.2035.13.camel@shrek.rexursive.com>
	 <1333620908.8191.1.camel@shrek.rexursive.com>
	 <2cbc3801-3ab0-4ef6-84cd-d69a23ff4dcc@email.android.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 10:14 +1000, Bojan Smojver wrote:
> Please ignore this request. As it turns out, the hangs are still
> there, it just takes a bit longer to trigger.

Thanks to Per Olofsson, who actually determined what was going on, we
now know what the problem is.

My "free pages" maths used nr_free_pages() macro, which deals with all
free pages. However, we only allocate buffers from non-high zones. So,
on systems where there is a significant number of high pages free, we
get a very large number (even if only a quarter is used), which then
gets the kernel into a bind and eventually hangs it on page allocation.

Will send a patch shortly, which will also have some other fixes.

-- 
Bojan

