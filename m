Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2DGSgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 14:36:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52892 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab2DGSgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 14:36:49 -0400
Message-ID: <4F80892A.7050104@zytor.com>
Date: Sat, 07 Apr 2012 11:36:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: RFC: deprecating/removing the legacy mode of devpts
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, devpts supports a legacy mode where only one instance exists.
 For backwards compatibility, this is also the default mode, but the
right thing should be to migrate everyone over to the "newinstance" scheme.

However, it is increasingly clear that that is not happening; neither
the distros nor udev support this by default at this point.

I think it might be time we set a sunset date for the legacy mode,
probably around kernel 3.9 at this point.

The big change is that /dev/ptmx instead of being a device node should
be a symlink to /dev/pts/ptmx, which is then either chmodded to the
proper permissions, or given proper permissions via the ptmxmode mount
options to devpts.  The latter is probably preferable from a technical
point of view since it doesn't create a "gap".

As such, I would like to suggest the following:

1. For 3.5, add this to feature-removal.txt.
2. For 3.6, remove CONFIG_DEVPTS_MULTIPLE_INSTANCES as a configuration
   option, and printk a warning if devpts is mounted without the
   "newinstance" option.
3. For 3.9 remove the legacy support including support for a ptmx node
   outside the devpts filesystem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

