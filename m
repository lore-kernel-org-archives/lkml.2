Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab0LPRZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:25:33 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48116 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764Ab0LPRZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:25:28 -0500
Date: Thu, 16 Dec 2010 07:50:54 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Mariusz Kozlowski <mk@lab.zgora.pl>, Dipankar Sarma <dipankar@in.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rculist: fix borked __list_for_each_rcu() macro
Message-ID: <20101216155054.GB2203@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292451072-5095-1-git-send-email-mk@lab.zgora.pl>
 <20101215232005.GB6595@linux.vnet.ibm.com>
 <20101216060236.GB4826@mako-laptop>
 <20101216073840.GA5313@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101216073840.GA5313@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 03:38:40PM +0800, Américo Wang wrote:
> On Thu, Dec 16, 2010 at 07:02:36AM +0100, Mariusz Kozlowski wrote:
> >On Wed, Dec 15, 2010 at 03:20:05PM -0800, Paul E. McKenney wrote:
> >> On Wed, Dec 15, 2010 at 11:11:12PM +0100, Mariusz Kozlowski wrote:
> >> > This restores parentheses blance.
> >> 
> >> Good catch, queued!!!
> >> 
> >> This does not actually appear to be in use anywhere in the kernel any
> >> more, so I queued this for 2.6.38 rather than in the 2.6.37 urgent queue.
> >> So, just out of curiosity, how did you find this one?
> >
> >Some years ago I wrote a dumb script that walks trees of () and {}.
> >It catches unbalanced trees. It's dumb enough to fail with #ifdef etc,
> >but most of the time it does its job. It reaches unreachable code
> >and unused one too.
> 
> gcc will complain about this, however, in this case, it is used.

Hello, Américo!

I did a "git grep -l __list_for_each_rcu" and its output was only:

	include/linux/rculist.h:#define __list_for_each_rcu(pos, head) \

This was in Linus's tree.  And gcc certainly would have failed if
this macro had been used in any recent build.

It really was used some time back, but it appears to me that those
uses no longer exist.

Or are you saying that you have a patch on its way in that needs
this macro?  If so, please point me at it.

							Thanx, Paul
