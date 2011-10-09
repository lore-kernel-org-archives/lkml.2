Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab1JIGDi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 02:03:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42967 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751213Ab1JIGDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 02:03:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18TDYgQDUMTyXmw+fgEqXa330JNsyUcZQSCmjRw9+
	CRC8XhbR5UGy3j
Subject: Re: 2.6.32 / RH 6.1 scheduler bloated
From: Mike Galbraith <efault@gmx.de>
To: Robert Kubrick <robertkubrick@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <35C27021-40FC-4127-BC82-9F86FA9D624A@gmail.com>
References: <35C27021-40FC-4127-BC82-9F86FA9D624A@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Oct 2011 08:03:33 +0200
Message-ID: <1318140213.6216.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-08 at 20:26 -0400, Robert Kubrick wrote:
> A simple ftrace wakeup test shows 10us latency during the idle-to-run
> transition:

If you boot nohz=off idle=poll, and measure with cyclictest (measure in
userspace for free), you'll likely see a remarkable difference.

Coming out of idle can be slow, but that has more to do with silicon
than scheduler bloat (not that bloat doesn't exist mind you).  My Q6600
box _sucks_ at getting off it's duff, even intel_idle.max_cstate=1 is
horrid. E5620 gets moving > order of magnitude more quickly with the
same kernel/config/params.

	-Mike

