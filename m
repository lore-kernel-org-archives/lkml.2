Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0EQS1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:27:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36603 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0EQS1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:27:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Z4wNpyYwb7WZHZ8m1pfdvFMGFILa2Le78vNyhVL4iNCOxguERaY9TwJQPuoRVFBDH
	8kxUEAhWQ/0vzzqUDOd9g==
MIME-Version: 1.0
In-Reply-To: <20100517181252.GA14260@gandalf>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
	 <87hbm6cz90.fsf@deeprootsystems.com>
	 <1274115885.4418.59.camel@mulgrave.site>
	 <20100517174647.GA11512@gandalf>
	 <1274119179.4418.68.camel@mulgrave.site>
	 <20100517181252.GA14260@gandalf>
Date: Mon, 17 May 2010 11:26:59 -0700
Message-ID: <AANLkTikueXPEWEHQt-Fl3Xvb3EB4ntsBlJUjjtmpinGK@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: me@felipebalbi.com
Cc: James Bottomley <James.Bottomley@suse.de>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 11:12 AM, Felipe Balbi <me@felipebalbi.com> wrote:
>
>> The technical reason for wanting suspend blockers (as has been stated
>> more times than I can be bothered to go back and count) is that no-one
>> can currently produce a working model for race free kernel to user work
>> handoff and, in the face of open app stores, rogue applications are a
>> significant problem.  The fact that suspend blockers enables easy
>> identification of power hogging apps is just a very useful side effect.
>
> I still can't get over the fact that suspend_blockers are dealing with
> userland problems in kernel space. If we can't really trust apps, I'm
> sorry but companies like Google and Nokia (which I work for) will have
> to setup better application acceptance on their stores.

We (Google) would like to allow completely open app distribution with
minimal hurdles, and avoid the walled garden approach.  Toward this
goal we're not even requiring the use of a central app store for
distribution.

Obviously, given the ability to run *any* app, users will run into bad
(or perhaps just less-than-optimal-powerwise) apps.  Being able to
provide the best possible battery life (in spite of
sometimes-nonoptimal userspace apps) and simultaneously informing
users about which apps are better/worse for their battery life is a
goal here.

> IMO we should be celebrating good apps, not dealing in kernel space with
> bad ones. And on top of all that, we would still need custom
> applications with suspend_blockers support built into them.

For a large majority of apps, running in the background while the
device is asleep (screen off) is not essential, they don't request the
"keep device awake" permission, never hold a wakelock, etc.  Those
that do need to do this have the permission, may hold suspend
blockers, and are accounted for.

Unrelated to apps, the ability to say "please enter suspend as soon as
there's no more work (kernel or userspace) preventing it", in a
simple, non-racy way is useful.

Brian
