Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0EQXEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:04:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:36534 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab0EQXEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:04:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=N6v+AXKPh2huseuG/4EEDf6SOjazjAfiR6An2XPnzMl9zSDMMAYg9Topn8OnYNJYP
	uXwrjmAakh0cyyanxtAQA==
MIME-Version: 1.0
In-Reply-To: <87mxvyt9xz.fsf@deeprootsystems.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <20100503215028.GB18910@srcf.ucam.org>
	 <alpine.DEB.2.00.1005141408260.3348@utopia.booyaka.com>
	 <20100514203202.GA12409@srcf.ucam.org>
	 <87aas2azc5.fsf@deeprootsystems.com>
	 <20100514231510.GG16989@thunk.org>
	 <87r5laa4oc.fsf@deeprootsystems.com>
	 <AANLkTilL90pYVlquvMDAEPHj_AraEi9Qzk-0tTjw9Bkx@mail.gmail.com>
	 <AANLkTil7358FHTlFZ0LqwymkiZZ-7An0HlaOTVhTkpgW@mail.gmail.com>
	 <87mxvyt9xz.fsf@deeprootsystems.com>
Date: Mon, 17 May 2010 16:04:21 -0700
Message-ID: <AANLkTim5PZdKvH2HsDXtpzIPTNbVC54C4Y_YwbNVuypk@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Mike Chan <mike@android.com>, Vitaly Wool <vitalywool@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Oleg Nesterov <oleg@redhat.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-omap@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       Daniel Walker <dwalker@codeaurora.org>, tytso@mit.edu,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Geoff Smith <geoffx.smith@intel.com>, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 3:55 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
>
> The fundamental problem is one of idleness.  What we want is the
> system to be idle in order to hit the lowest power states.  We can't
> get there because the system is not truly idle.
>
> So, there are basically two solutions:
>
> 1) find and fix the problem spots so we can be idle more often
> 2) add a new definition of idle so we can be idle more often
>
> Opporuntistic suspend takes the second approach where the new
> definition of idle is "no suspend blockers held."
>
> Of course, I clearly prefer the former, but it's also becoming clear
> that since I'm the only one still whining about it, I must be too much
> of an idealist to keep hoping for it.

I'd love to see the former work, but it is not something that I think
is going to be fixed rapidly.  It potentially involves many different
subsystems, and still requires some need for managing arbitrary
userspace agents which may have non-ideal behaviors (if we're going to
solve the problem for general purpose devices that can run arbitrary
user-installed software).  Incremental improvements are great though
(for example, that we can now be in lowest power idle for periods
greater than 2 seconds due to the change in .32).

Even when operating in opportunistic suspend, it is still advantageous
for idle to be as idle as possible and we should keep working toward
that goal.  If we get to the point where the power difference between
suspend-in-idle and opportunistic suspend is zero, then we no longer
need the latter.

I don't think anybody on the Google/Android side is arguing that we
*shouldn't* pursue dynamic pm and overall making idle more idle more
of the time.  We're just saying that here and now we are not at the
ideal and opportunistic suspend gains us real power savings and is
useful.

Brian
