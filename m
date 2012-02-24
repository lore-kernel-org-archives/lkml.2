Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2BXAFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:05:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54354 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab2BXAFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:05:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.166 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Thu, 23 Feb 2012 16:05:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/10] 3.2.8-stable review
Message-ID: <20120224000510.GA1005@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, this is a "special" review cycle, only containing a single, large
bugfix for the reported floating point problem reported by some wireless
users.  It would be VERY good if anyone running a x86-32 machine and a
wireless driver test this out to verify that it works properly.

This is the start of the stable review cycle for the 3.2.8 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Feb 26 00:00:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.2.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                           |    4 +-
 arch/x86/include/asm/i387.h        |  284 +++++++++++++++++++++++++++++-------
 arch/x86/include/asm/processor.h   |    1 +
 arch/x86/include/asm/thread_info.h |    2 -
 arch/x86/kernel/process_32.c       |   25 +---
 arch/x86/kernel/process_64.c       |   29 +---
 arch/x86/kernel/traps.c            |   41 +++--
 arch/x86/kernel/xsave.c            |   12 +-
 arch/x86/kvm/vmx.c                 |    2 +-
 9 files changed, 270 insertions(+), 130 deletions(-)

