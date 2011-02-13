Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1BMGWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:22:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57446 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab1BMGWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FFx+89k+xtMQfMvT28NCTKcFEBBbtQ2CQf8616mxnp68DCqQQgRw3bg/ZgxNaNCkz0
         e293SXc/IdMoJq99N9eguemyZZivPFQPUn/UDYTn/KaWOXJBOSMY396yofEP6BO1SHGG
         4arRxZeLl4U9QnDRufbzNPussUBwJx4C/DMS0=
Date: Sun, 13 Feb 2011 14:22:14 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Chris Wright <chrisw@sous-sol.org>
Subject: Regression - Xorg start failed
Message-ID: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

With kernel built from current linus's tree, I can not start xorg,
it failed with:

Backtrace:
0: X(xorg_backtrace+0x26) [0x4e8bb6]
1: X(xf86SigHandler+0x39) [0x489989]
2: /lib64/libc.so.6 [0x7f077a6b9f30]
3: /usr/lib64/libpciaccess.so.0(pci_device_get_bridge_buses+0xf1) [0x7f077c101fd1]
4: X(initPciBusState+0x8d) [0x470abd]
5: X(xf86AccessInit+0xe) [0x48e26e]
6: X(InitOutput+0x108b) [0x466bfb]
7: X(main+0x20e) [0x42ceee]
8: /lib64/libc.so.6(__libc_start_main+0xe6) [0x7f077a6a5526]
9: X [0x42c529]

Fatal server error:
Caught signal 11.  Server aborting

The graphic driver I used is intel (i915)

Finally I bisected it, results:
47970b1b2aa64464bc0a9543e86361a622ae7c03 is first bad commit
commit 47970b1b2aa64464bc0a9543e86361a622ae7c03
Author: Chris Wright <chrisw@sous-sol.org>
Date:   Thu Feb 10 15:58:56 2011 -0800

    pci: use security_capable() when checking capablities during config space read
    
    Eric Paris noted that commit de139a3 ("pci: check caps from sysfs file
    open to read device dependent config space") caused the capability check
    to bypass security modules and potentially auditing.  Rectify this by
    calling security_capable() when checking the open file's capabilities
    for config space reads.
    
    Reported-by: Eric Paris <eparis@redhat.com>
    Signed-off-by: Chris Wright <chrisw@sous-sol.org>
    Signed-off-by: James Morris <jmorris@namei.org>

:040000 040000 e14ad9470ca5f84f13cd31eaf5def16d40bc54f1 cbf987647b8052214dd928c87c6becfb639e4ca2 M      drivers

Any idea?

--
Thanks
Dave
