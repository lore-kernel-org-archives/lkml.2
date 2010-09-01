Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0IAAIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 20:08:23 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:53781 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751125Ab0IAAIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 20:08:21 -0400
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Aug 2010 20:08:21 EDT
Subject: Re: [PATCH 5/6 v2] HID: magicmouse: enable Magic Trackpad support
From: Michael Poole <mdpoole@troilus.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1283280068-12285-5-git-send-email-chase.douglas@canonical.com>
References: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
	 <1283280068-12285-5-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 20:08:15 -0400
Message-ID: <1283299695.13785.16.camel@graviton>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 14:41 -0400, Chase Douglas wrote:
> The trackpad speaks a similar, but different, protocol from the magic
> mouse. However, only small code tweaks here and there are needed to make
> basic multitouch work.
> 
> Extra logic is required for single-touch emulation of the touchpad. The
> changes made here take the approach that only one finger may emulate the
> single pointer when multiple fingers have touched the screen. Once that
> finger is raised, all touches must be raised before any further single
> touch events can be sent.
> 
> Sometimes the magic trackpad sends two distinct touch reports as one big
> report. Simply splitting the packet in two and resending them through
> magicmouse_raw_event ensures they are handled properly.
> 
> I also added myself to the copyright statement.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---
>  drivers/hid/hid-core.c       |    1 +
>  drivers/hid/hid-ids.h        |    1 +
>  drivers/hid/hid-magicmouse.c |  229 ++++++++++++++++++++++++++++++++----------
>  3 files changed, 176 insertions(+), 55 deletions(-)

Acked-by: Michael Poole <mdpoole@troilus.org>

One behavior that slightly surprised me -- which I believe is a quirk
due to userspace not expecting touchpads to have button switches -- is
that touches on the trackpad that do not close the switch can still be
interpreted by X as clicks.

Once the discussions about if/how to tweak this code settle down, I'll
put together a patch to change the "down" and "last_up" logic as I
suggested earlier.

Michael Poole

