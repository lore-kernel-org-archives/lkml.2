Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab1DZVgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:36:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54187 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758739Ab1DZVgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:36:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for device PM.
Date: Tue, 26 Apr 2011 23:36:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com> <201104262249.22564.rjw@sisk.pl> <20110426211159.GB28033@elf.ucw.cz>
In-Reply-To: <20110426211159.GB28033@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104262336.56347.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 26, 2011, Pavel Machek wrote:
> Hi!
> 
> > > > What is the root problem that this is trying to solve?
> > > 
> > > It is trying to fix machines that need to run periodic kernel tasks
> > > even when user asked them to sleep. Zaurus needs to periodicaly wake
> > > up to be able to charge battery in s2ram state, for example.
> > 
> > Well, if you wake up periodically, it's not S2RAM any more, I'd say.
> 
> It certainly looks a lot like s2ram to the user.
> 
> Now, your PC wakes up periodically in s2ram, too; but it is keyboard
> controller that wakes up, not CPU, so you do not know.

I seriously doubt it's a keyboard controller in contemporary machines.

Yes, there are parts of them that don't actually sleep, but that's not
under OS control.

> On Zaurus, you do not know, either; nothing visible happens and
> userspace is shielded from these details.

If you wake up device drivers, it _is_ visible.  Maybe not to user
space, but that's a semantic difference.

> Should user really have to know if battery charger is implemented on
> keyboard controller or on main cpu before he selects which interface
> to use?

Please don't confuse user space with the user.  You can resume all the
way to user space without turning the backlight on and the user will not
notice, right?

Rafael
