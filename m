Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0JXCiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 22:38:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53981 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0JXCiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 22:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:x-operating-system:x-location
         :x-accept-language:user-agent;
        b=HQZaOG75FdkP3dJnuRa8XJUOy+wUGN4sKSL1X8Mwd1kEXtZWc2rw5RdGsvA8Sf93S/
         8DwbLbNh1Q3HyM6ZQcfRZgYXXDm64QZS2fJWsYmj3Ra0k1PbfWzcs8vfnlcwWhmqbmT5
         pJgFXYUnQ+joy2ZKmhCjZIdJOap16eOaNNmq0=
Date: Sun, 24 Oct 2010 04:40:24 +0200
From: Christian Ruediger Bahls <lkml@qb352.de>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Len Brown <len.brown@intel.com>
Subject: Re: intel_idle .. Was: __pm_runtime_resume() returns -1 Was:
 Regression in 2.6.36
Message-ID: <20101024024024.GA2459@pfau.e-technik1.uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010231356570.2565@localhost.localdomain>
 <201010231957.28276.rjw@sisk.pl>
 <alpine.LFD.2.00.1010231346110.2565@localhost.localdomain>
X-Operating-System: Linux 2.6.36-rc7 x86_64
X-Location: Rostock
X-Accept-Language: de, en
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[2010-10-23 19:49] Len Brown <lenb@kernel.org> wrote:
> 
> > and yes indeed booting with "intel_idle.max_cstate=0"
> > makes the system work again
> 
> Please file a sighting here:
> https://bugzilla.kernel.org/enter_bug.cgi?product=Power%20Management
> component: intel_idle

https://bugzilla.kernel.org/show_bug.cgi?id=21032

[2010-10-23 19:58] Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > in later versions of the kernel it throws the 
> >  "__pm_runtime_resume() returns -1"-warnings
> 
> Do you have CONFIG_PM_VERBOSE set in your .config by chance?

Yes i have

[2010-10-23 20:04] Len Brown <lenb@kernel.org> wrote:
> describe symptoms (I think this is a fully reproducible boot hang, yes?)

yes, fully reproducible boot hang
 (hangs "best" with max_cstate=2

> try intel_idle.max_cstate=1, include dmesg
> and increase the '1' until it fails
> My guess is that 1 will work, but some higher number will start failing.

yes, max_cstate=4 works better(like in: hanging less often) than max_cstate=2

> without any other bootparams, try "nolapic_timer"

yes .. this helps .. dmesg's attach to bug report mentioned above

> thanks,
> Len Brown, Intel Open Source Technology Center

Thank you very much as well :)

yours
  Christian

