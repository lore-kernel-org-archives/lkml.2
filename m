Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1DSTw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:52:29 -0400
Received: from svc.spearhead.de ([85.214.96.164]:36929 "EHLO mx.spearhead.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1DSTw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:52:28 -0400
From: Nicos Gollan <ngollan@spearhead.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Mysterious freezes after 2.6.35, no NMI
Date: Tue, 19 Apr 2011 21:52:25 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.35-trunk-amd64; KDE/4.6.1; x86_64; ; )
References: <201104121939.59910.ngollan@spearhead.de> <20110419143031.GA21993@redhat.com>
In-Reply-To: <20110419143031.GA21993@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104192152.25628.ngollan@spearhead.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 19 April 2011 16:30:31 Don Zickus wrote:
> On Tue, Apr 12, 2011 at 07:39:59PM +0200, Nicos Gollan wrote:
> > To add insult to injury, at least in the 2.6.38 series, the NMI watchdog
> > is broken. The counters in /proc/interrupts always show 0, but will
> > count up quite happily on 2.6.35.
> 
> The nmi watchdog changed for 2.6.36, such that it increments every 60
> seconds instead of every second.  Using cpuspeed and a lightly loaded
> system, will delay it even longer.  This is a good thing as you don't need
> nmi interrupts firing all the time.

In how far does that change the time until the watchdog would trigger after a 
freeze? Would it react on the first or second execution after the freeze? That 
would make it "two minutes or even longer", depending on the CPU frequency 
that was set when the control daemon died.

IMO that slow and nondeterministic behaviour is detrimental to the watchdog's 
declared function. With those changes, there's no idea how long one would have 
to wait after a freeze. There should at least be a fixed upper limit on the 
execution period, and according changes to Documentation/nmi_watchdog.txt

Regards,
Nicos
