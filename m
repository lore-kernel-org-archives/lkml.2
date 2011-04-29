Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640Ab1D2QAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:00:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49827 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab1D2QAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZBxAQlgO8/gzzEBU35eaNxiZO9khmCLS4yYpomN6iRljg+7GLRFouZII8NMxQPqAO5
         CCzSmFSftKJPzGBBf3F3U5xRCCvW5AL7lbM1S+os1okqEd41voBECmARIB9cEan49VqV
         phjpYIZ8RgbMoDfnsAQZmltvrV2dwhW80oruE=
Date: Fri, 29 Apr 2011 18:00:39 +0200
From: Tejun Heo <tj@kernel.org>
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Message-ID: <20110429160039.GP16552@htj.dyndns.org>
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
 <BANLkTi=aED731W4WoKK1HUU88qR7RxpW6Q@mail.gmail.com>
 <BANLkTimDOz7M6m6Xo==DbLHP6q2pMBzd9g@mail.gmail.com>
 <201104172135.40189.arnd@arndb.de>
 <BANLkTimS2DqZTjq3Kx-p8CfZ5iFra_M2DA@mail.gmail.com>
 <20110426131132.GG878@htj.dyndns.org>
 <BANLkTin71zQH2qDNiwPp6vQppy3YWhbj2A@mail.gmail.com>
 <20110428103036.GB10721@htj.dyndns.org>
 <BANLkTinK3jZmKewkbtmOn54cRXhszh_5sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinK3jZmKewkbtmOn54cRXhszh_5sQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 29, 2011 at 01:56:46AM +0200, Thilo-Alexander Ginkel wrote:
> On Thu, Apr 28, 2011 at 12:30, Tejun Heo <tj@kernel.org> wrote:
> > Does your kernel have preemption enabled?
> 
> CONFIG_PREEMPT is not set
> 
> > If not, does the following patch fix the problem?
> 
> Yep, looks good so far (at least in my virtualized test environment):
> 2.6.39-rc4 with your patch applied survived 100 suspend/resume cycles
> w/o locking up.

Awesome, I'll forward the patch to mainline and -stable.

> Just out of curiosity: Was this a new issue in 2.6.39-rc4 ord could
> this fix be backported to 2.6.38?

This needs to be backported.  It's an issue which has been there from
the initial implementation of cmwq.  It needs non-preemptive kernel
and rescuer kicking in at a very bad timing, so not many people seem
to have been affected by this.  Your setup somehow triggers it
reliably.

Thank you.

-- 
tejun
