Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2APCjk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 21:39:40 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:48791 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753032Ab2APCjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 21:39:39 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/TxmY8nJnTtrE1F/2hfMNvkm8Dfl16yZjAr/Pqz1
	vLcFFqjkPAY57N
Subject: Re: Chronic resource starvation.
From: Mike Galbraith <efault@gmx.de>
To: Mike Mestnik <cheako@mikemestnik.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4F1322A6.7090009@mikemestnik.net>
References: <4F10F3AE.3030801@mikemestnik.net>
	 <4F11E3B8.6090007@mikemestnik.net>
	 <1326629295.6352.14.camel@marge.simson.net>
	 <4F1322A6.7090009@mikemestnik.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 03:39:34 +0100
Message-ID: <1326681574.6446.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 13:01 -0600, Mike Mestnik wrote:
> On 01/15/12 06:08, Mike Galbraith wrote:

> >> Does this behavior look normal or is it just my system?  If it is normal
> >> how difficult would it be to make corrections and would those
> >> corrections likely be kernel or application related?
> > That "Backup complete" makes me suspect a classic case of IO-itis.  If
> > bits of your GUI were pushed out or ram (or weren't previously used),
> > and live on a disk you're beating hell out of, you get to experience
> > horrid interactivity while those missing bits are being retrieved.
> Thank you for the reply!
> 
> That's DVDShrink, copies from optical drive(slow) to disk(fast-ish?).
> http://www.dvdshrink.info/
> 
> That wouldn't explain why the monitor(gkrellm) stopped updating, every
> part of that is pooling like top would.  Gkrellm indicates disk activity
> and it shows the backup complete on sr1 and a backup in progress on sr0,
> however neither of these operations rate on Disk or sda.

No, dvdshrink wouldn't do enough IO to matter much.  Heavy IO can (or
could) cause symptoms like your video though, all of it.  I used to be
able to trigger loss of GUI control for 30 minutes at a time.  All it
took was something poking fdatasync after a large streaming IO had been
running for a while.

Another IO thing that can cause horrible interactivity is IO error
recovery.  That can (or again, could) make a box lurch like hell.  If
that were the cause, you'd have kernel gripes in dmesg output.

	-Mike

