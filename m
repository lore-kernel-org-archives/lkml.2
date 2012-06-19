Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab2FSPqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:46:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47627 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2FSPqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:46:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1206152313310.3086@ionos>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 19 Jun 2012 09:45:51 -0600
Message-ID: <CAErSpo5182ZzmmQXci=n=YZrktS6hUWq=Dq9bqDpA9KFpP3VnQ@mail.gmail.com>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the question!
To: Thomas Gleixner <tglx@linutronix.de>
Cc: ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 4:56 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>   - How do we cope with the need to review the increasing amount of
>     (insane) patches and their potential integration?

There's certainly a problem here.  Sometimes I see patches that are
technically correct, but there's a philosophical discussion about
whether a design or user interface change is desirable.  Those are fun
and interesting to deal with.

The bigger problem for me is that many patches do something useful and
desirable but have some obscure technical problem, and it's hard to
catch them.  Usually these patches come from competent submitters who
merely don't know where all the landmines in the current design are
buried.

As a trivial example, a recent patch added a PCI "final" fixup.  Seems
perfectly reasonable, except that final fixups aren't applied to
hot-added devices.  That's a bug in PCI, and we shouldn't expect
everybody who writes a quirk to know about it.

We can try to address this by "educating developers" or "documenting
the design better" or "delegating to submaintainers" or whatever.
Those are valuable, but in some way they're cop-outs.  A more
effective fix would be to remove the landmines, reduce complexity, and
improve the design.  If we have coherent code that follows the
hardware architecture and matches people's intuition about how things
"should work," I think we'll get patches with fewer issues.

Sorry, I think I just reiterated what you, Greg KH, Alan, et al have
already said :)
