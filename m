Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750865Ab1BEFhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 00:37:38 -0500
Received: from smtp.outflux.net ([198.145.64.163]:47861 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab1BEFhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 00:37:38 -0500
Date: Fri, 4 Feb 2011 21:37:16 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
        tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/urgent] x86-32: Make sure the stack is set up before we
 use it
Message-ID: <20110205053716.GR5503@outflux.net>
References: <4D41E86D.8060205@free.fr>
 <tip-43d79a250bdb10e30b08a79e906befc691c3f5ce@git.kernel.org>
 <20110205021922.GP5503@outflux.net>
 <4D4CD411.6070800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4CD411.6070800@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 08:37:37PM -0800, H. Peter Anvin wrote:
> On 02/04/2011 06:19 PM, Kees Cook wrote:
> > This works for me doing CPU hotplugging on ia32, but on x86_64 it hangs.
> > (Both boot, though.)
> 
> I can't reproduce the failure here, and it's hard to see how this patch
> would make a significant change on 64 bits.  Could you try reverting
> *only* the head_64.S hunk and try it on your platform again?

With the head_64.S hunk dropped, it runs fine. My highly fine-tuned
test-case is:

  while :; do ls -la / -R >/dev/null 2>/dev/null; done &
  while :; do echo 0 > /sys/devices/system/cpu/cpu1/online ; echo 1 > /sys/devices/system/cpu/cpu1/online ; done &

Looks good from this end. Thanks!

-Kees

-- 
Kees Cook
Ubuntu Security Team
