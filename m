Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0IABzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:55:23 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40619 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab0IABzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:55:21 -0400
Subject: Re: [PATCH 5/6 v2] HID: magicmouse: enable Magic Trackpad support
From: Chase Douglas <chase.douglas@canonical.com>
To: Michael Poole <mdpoole@troilus.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1283299695.13785.16.camel@graviton>
References: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
	 <1283280068-12285-5-git-send-email-chase.douglas@canonical.com>
	 <1283299695.13785.16.camel@graviton>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 21:55:10 -0400
Message-ID: <1283306110.2255.349.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 20:08 -0400, Michael Poole wrote:
> One behavior that slightly surprised me -- which I believe is a quirk
> due to userspace not expecting touchpads to have button switches -- is
> that touches on the trackpad that do not close the switch can still be
> interpreted by X as clicks.

This is actually done by the X synaptics input module. It's the defacto
X touchpad driver and enables niceties like two finger scrolling and
whatnot. You can either use it as is, use xinput/xorg.conf to manipulate
its configuration, or switch to the X evdev input module which is more
"bare" support.

FYI, our gesture support in Maverick is based on a modified version of
the X evdev input module. However, because the whole stack of desktop
libs and toolkits won't support gestures in Maverick, you lose things
like two finger scroll. Thus, we're going to leave the default X input
module for the magic trackpad to synaptics in Ubuntu.

> Once the discussions about if/how to tweak this code settle down, I'll
> put together a patch to change the "down" and "last_up" logic as I
> suggested earlier.

I actually decided to tackle this to make the patches I'm writing
easier. I'll be sending a new batch shortly.

Thanks,

-- Chase

