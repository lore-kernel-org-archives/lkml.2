Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2JPPUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:20:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803Ab2JPPUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:20:37 -0400
Date: Tue, 16 Oct 2012 11:20:23 -0400
From: Dave Jones <davej@redhat.com>
To: Michael Spang <spang@chromium.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, greno@verizon.net,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: USB keyboard backlight powering down.
Message-ID: <20121016152023.GA25506@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Michael Spang <spang@chromium.org>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, greno@verizon.net,
	Fedora Kernel Team <kernel-team@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerry (CC'd) reported a bug to us that since 3.6.1, his illuminated
Logitech USB keyboard doesn't light up until he hits a key, and then
it immediately powers back off, defeating the purpose of having an
illumated keyboard.

Looking over the 3.6.1 changelog, I see this change, which sounds
like it might be responsible ?

commit ee537508bdc0c00b96ac497f3d82a68f820e6182
Author: Michael Spang <spang@chromium.org>
Date:   Fri Sep 14 13:05:49 2012 -0400

    Increase XHCI suspend timeout to 16ms
    
    commit a6e097dfdfd189b6929af6efa1d289af61858386 upstream.
    
    The Intel XHCI specification says that after clearing the run/stop bit
    the controller may take up to 16ms to halt. We've seen a device take
    14ms, which with the current timeout of 10ms causes the kernel to
    abort the suspend. Increasing the timeout to the recommended value
    fixes the problem.
    
    This patch should be backported to kernels as old as 2.6.37, that
    contain the commit 5535b1d5f8885695c6ded783c692e3c0d0eda8ca "USB: xHCI:
    PCI power management implementation".
    
    Signed-off-by: Michael Spang <spang@chromium.org>
    Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Any thoughts on how we could prevent this generically, or is this
something we're going to have to quirk around for specific devices we
don't want to power down ?

	Dave

