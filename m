Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab1ANNkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 08:40:02 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57114 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab1ANNkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ONQcYT/Sl+at/NVkS/029tjyYhmxoSSDbI+hCWM7ljM7fnyOBbZdQ3RcQYSN9c0dks
         +eUnNYD/JLEjZB9+01G6Lbc8BF1Zk1Iq3h81KbLzKfRKVYlYY4PwbbyXYs112t6PPJ8B
         qY/Q3gOXs1yRc0DXMZt8X85/tqIw1hJ595U98=
Date: Fri, 14 Jan 2011 15:39:55 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Saving early panic() messages, to disk, using the BIOS
Message-ID: <20110114133955.GA31019@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm facing some very early panics in latest -rc kernels. Vesafb is not
even working, so only the very bottom of the stack trace is available.

>From an overall-design perspective, would a patch that saves such early
panic messages to the hard-disk using real-mode BIOS calls be acceptable?

That seems to be the only path to _fully_ capture such panic; this is a
regular x86(-64) laptop with no serial ports or floppy disks. I'm in the
lmode->pmode->rmode part now, but I thought it might be wise to quickly
ask about such design mergeability before investing further effort.

(There is an old set of patches in Randy's homepage that does something
similar using floppy disks,[1] so it seems the basic idea is not that
strange. I also do something similar in a hobby kernel of mine.[2])

thanks,

[1] http://www.xenotime.net/linux/kmsgdump/
[1] http://gitorious.org/cute-os/cute/

-- 
Darwish
