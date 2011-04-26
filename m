Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1DZNLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:11:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54572 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1DZNLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=KjPZFwO0P00PQtWDHTLP73zlcecsnopFvT6vitZVPspqh9qQJfKXEcFLohc6sD0Elm
         +WsLPPDZwhL6tA+TOU5Zv+LEiFUNRXawBbGkRLNWtvbTJbbzKfe2GAgPjRbH/Lp/twoA
         O0Wl5j4reQus5jAXpBNIls9IGW95xa7lwBr2U=
Date: Tue, 26 Apr 2011 15:11:32 +0200
From: Tejun Heo <tj@kernel.org>
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Message-ID: <20110426131132.GG878@htj.dyndns.org>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com>
 <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de>
 <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, sorry about the delay.  Was on the road and then sick.

On Sun, Apr 17, 2011 at 11:53:42PM +0200, Thilo-Alexander Ginkel wrote:
> >> | e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c is the first bad commit
> >> | commit e22bee782b3b00bd4534ae9b1c5fb2e8e6573c5c
> >> | Author: Tejun Heo <tj@kernel.org>
> >> | Date:   Tue Jun 29 10:07:14 2010 +0200
> >> |
> >> |     workqueue: implement concurrency managed dynamic worker pool
> >
> > Is it possible to make it work by reverting this patch in 2.6.38?
> 
> Unfortunately, that's not that easy to test as the reverted patch does
> not apply cleanly against 2.6.38 (23 failed hunks) and I am not sure
> whether I want to revert it manually ;-).

Yeap, reverting that one would be a major effort at this point.
Hmmm... assuming all the workqueue usages were correct, the change
shouldn't have introduced such bug.  All forward progress guarantees
remain the same in that all workqueues are automatically given a
rescuer thread.  That said, there have been some number of bug fixes
and cases where single rescuer guarantee wasn't enough (which was
dangerous before the change too but was less likely to trigger).

> >> If anyone is interested in getting hold of this VM for further tests,
> >> let me know and I'll try to figure out how to get it (2*8 GB, barely
> >> compressible due to dmcrypt) to its recipient.
> >
> > Adding dm-devel to Cc, in case the problem is somewhere in there.
> 
> In the meantime I also figured out that 2.6.39-rc3 seems to fix the
> issue (there have been some work queue changes, so this is somewhat
> sensible)

Hmmm... that's a big demotivator.  :-)

> and that raid1 seems to be sufficient to trigger the issue.
> Now one could try to figure out what actually fixed it, but if that
> means another bisect series I am not too keen to perform that
> exercise. ;-) If someone else feels inclined to do so, my test
> environment is available for download, though:
>   https://secure.tgbyte.de/dropbox/lockup-test.tar.bz2 (~ 700 MB)
> 
> Boot using:
>   kvm -hda LockupTestRaid-1.qcow2 -hdb LockupTestRaid-2.qcow2 -smp 8
> -m 1024 -curses
> 
> To run the test, log in as root / test and run:
>   /root/suspend-test

Before I go ahead and try that, do you happen to have softlockup dump?
ie. stack traces of the stuck tasks?  I can't find the original
posting.

Thank you.

-- 
tejun
