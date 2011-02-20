Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1BTRWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 12:22:21 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41153 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751928Ab1BTRWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 12:22:20 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18UBXMp/MIUTZQIcEg6KC+gRWJHxPDbFjfphYYB0B
	qXHClsPEKiXiY4
Subject: Re: [PATCH 5/5] sched, autogroup: runtime enable/disable tuning fix
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20110220141003.GA6006@zhy>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
	 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
	 <1298207379.7998.11.camel@marge.simson.net>  <20110220141003.GA6006@zhy>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Feb 2011 18:22:13 +0100
Message-ID: <1298222533.7881.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-20 at 22:10 +0800, Yong Zhang wrote:
> On Sun, Feb 20, 2011 at 02:09:39PM +0100, Mike Galbraith wrote:
> > On Sun, 2011-02-20 at 15:08 +0800, Yong Zhang wrote:
> > > Now enable/disable autogroup at runtime is just a flag,
> > > it doesn't take effect on current process of the system.
> > 
> > Yup, they only move upon migration, which can take up to forever.
> 
> Yeah. so on UP, the user can have autogroup forever or not, and
> sched_autogroup_enable is a nop.

Yup, and that's the best argument for doing the active switch.

> Apart from runtime enable/disable issue, I think patch1~3 could
> still be applied beause they really fix some problem or bring
> some improvement.

Yeah.

Your whole series looked fine to me at a glance (sunday;), with the
exception of #2, that one is maybe iffy, depending on point of view.

It's iffy only in that the proc interface is there to show the group
(whether used or not, it's not about tasks really, just group), so the
user can easily twiddle it if he so desires, which has nada to do with
the group being active or not.

That said, I'd agree to whacking the proc interface wholesale in a
heartbeat.  It's really a wart.  If it were frequently used, it'd be
indicative of failure for the whole concept.

	-Mike

