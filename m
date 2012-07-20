Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2GTTi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:38:26 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50171 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab2GTTiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:38:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle workers
Date: Fri, 20 Jul 2012 21:44:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org
References: <1342545149-3515-1-git-send-email-tj@kernel.org> <1342808550.2583.48.camel@twins> <20120720183400.GL32763@google.com>
In-Reply-To: <20120720183400.GL32763@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207202144.05154.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 20, 2012, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jul 20, 2012 at 08:22:30PM +0200, Peter Zijlstra wrote:
> > I really think people who use hotplug at high frequencies are on drugs
> > and doing it wrong.
> 
> I don't know.  It does make some sense.  It's not like we have any
> other mechanism to keep some processors completely quiesient, which
> could make a noticeable difference from powersaving POV compared to
> mostly idle.  Rafael, can you please chime in and explain how / where
> / how freqeuntly / etc CPU hotplug is used for powersaving?

Well, there are use cases I'm not really familiar with.

Pretty much the only use case I'm sufficiently familiar with is
suspend/hibernate where we unplug all of the nonboot CPUs at one point.

The other use cases, which I don't really think are entirely valid,
are on some ARM platforms where CPUs are unplugged instead of being put into
C-states or equivalent (because we don't have a good mechanism for handling
multiprocessor C-states; there's a set of patches for that waiting for
the merge window in the Len's tree).  I'm hoping to get rid of those
use cases in future entirely.

Thanks,
Rafael
