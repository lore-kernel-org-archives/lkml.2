Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab1DSTay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:30:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab1DSTax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:30:53 -0400
Date: Tue, 19 Apr 2011 10:30:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Nicos Gollan <ngollan@spearhead.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Mysterious freezes after 2.6.35, no NMI
Message-ID: <20110419143031.GA21993@redhat.com>
References: <201104121939.59910.ngollan@spearhead.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104121939.59910.ngollan@spearhead.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 07:39:59PM +0200, Nicos Gollan wrote:
> To add insult to injury, at least in the 2.6.38 series, the NMI watchdog is 
> broken. The counters in /proc/interrupts always show 0, but will count up 
> quite happily on 2.6.35.

The nmi watchdog changed for 2.6.36, such that it increments every 60
seconds instead of every second.  Using cpuspeed and a lightly loaded
system, will delay it even longer.  This is a good thing as you don't need
nmi interrupts firing all the time.

But if after sticking a load on the system for 10 minutes, the NMI
interrupt doesn't increment, then I would be concerned.

Cheers,
Don
