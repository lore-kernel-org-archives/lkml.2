Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0JCWEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 18:04:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47838 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0JCWEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 18:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=rCjEYGqdrAGlNCoUB1yclTrkIsaT08o2M/YRgDlg9FZpz1Wih+rx5heaw5gB7/1K8E
         G4ZSMgwyUuwgI4RK/6U4oN+JGTZDaAaORWAmvjxSO3Tvm1oa01N4C0ftV1S9L5aDakMD
         5J5QBBPxtVdJmNBp2zyPy8R+Nb3X7eX9EahIw=
Date: Sun, 3 Oct 2010 15:04:20 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH 0/2] PM: Wakeup sources and async suspend
 error path bug fix
Message-ID: <20101003220420.GA3707@gvim.org>
Reply-To: markgross@thegnar.org
References: <201009201957.40995.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009201957.40995.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 07:57:40PM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> The following two patches are ready to go into linux-next from my point of
> view, so please let me know if there are any objections:
> 
> [1/2] - PM / Wakeup: Introduce wakeup source objects and event statistics (v3)
> 
> [2/2] - PM: Fix potential issue with failing asynchronous suspend
> 
> Thanks,
> Rafael

Sorry for the late response but, what user feed back will this provide
to the OS stack looking to put the system in a low power state?

There are 2 cases I can think of:
1) system wakes from an event that user mode needs to handle (i.e. key
press or phone ring or alarm events)
2) system wakes (or more likely, is blocked from suspending) by a
kernel critical section, say if USB-OTG is connected.

When wake's are of the type 1, then the power manager service could
simply wait for a user mode wake lock be taken and released from the
usermode before re-attempting to suspend.

When the wakes are of type 2, a power manager service thread would need
to do a select on a system file and be woken up to re-try the suspend
after the suspend-blocking is no longer needed.

Do you think I should cobble together an android PM driver that plugs
into your code to expose an ABI for the 2 cases listed above?

Also, with this do we want to revisit a pm_qos class for "active"
systems?  Or do you think thats redundant now?

--mark


