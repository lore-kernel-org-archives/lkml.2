Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab0EXWvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:51:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38851 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab0EXWvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:51:08 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: felipe.balbi@nokia.com,
       Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       "linux-pm\@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 8)
References: <1274482015-30899-1-git-send-email-arve@android.com>
	<201005240246.55043.rjw@sisk.pl> <20100524043224.GA31700@nokia.com>
	<201005242049.18920.rjw@sisk.pl>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 24 May 2010 15:51:05 -0700
In-Reply-To: <201005242049.18920.rjw@sisk.pl> (Rafael J. Wysocki's message of "Mon\, 24 May 2010 20\:49\:18 +0200")
Message-ID: <87wrusvrqe.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Monday 24 May 2010, Felipe Balbi wrote:
>> On Mon, May 24, 2010 at 02:46:54AM +0200, ext Rafael J. Wysocki wrote:
>> >On Saturday 22 May 2010, Arve Hjønnevåg wrote:
>> >> This patch series adds a suspend-block api that provides the same
>> >> functionality as the android wakelock api. This version adds a
>> >> delay before suspending again if no suspend blockers were used
>> >> during the last suspend attempt.
>> >
>> >Patches [1-6/8] applied to suspend-2.6/linux-next
>> 
>> funny thing is that even without sorting out the concerns plenty of 
>> developers had on the other thread, this series is still taken. What's 
>> the point in dicussing/reviewing the patches then ?
>
> I don't think the concerns you're referring to can be solved out.  
> Some people just don't like the whole idea and I don't think there's
> any way we can improve the patches to make them happy.  The only
> "solution" they would be satisfied with would simply be rejecting
> the feature altogether, although there are no practically viable
> alternatives known to me.

I'm not sure who the "some people" you're referring to are, but I'll
assume I'm included in that group.

I don't think this is a fair characterization of the objections, nor
do I think "rejecting the feature altogether" is the only satisfactory
answer.  Speaking for myself, I find the idea of being able to suspend
while idle a valid objective, and certainly see the usefulness of it
for embedded systems.  I'm also an owner and user of an Android phone,
so I am certainly not out just to make life difficult for Android.

The primary objection is not the end goal, but rather the
implementation.  In particular, the problematic redefintion of what it
means to be idle, or "not doing work that's immediately useful to the
user" to use the phrase from the changelog (where "useful" is still
not defined.)

This (re)definition completely bypasses all current idle
infrastructure based on timers, scheduler, etc. and makes "usefulness"
defined in terms of who holds suspend blockers.  This of course will
lead to a scattering of suspend blockers into any drivers/subsystems
considered "useful", which by looking through current Android kernels
is many of them.

Kevin
