Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1DLRZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:25:14 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:55234 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753272Ab1DLRZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:25:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAIiKpE1Ld/sX/2dsb2JhbAAMhD7TRJE0gSmDTXgElAqGag
X-IronPort-AV: E=Sophos;i="4.64,197,1301889600"; 
   d="scan'208";a="106139480"
Message-ID: <4DA48AF4.5080803@teksavvy.com>
Date: Tue, 12 Apr 2011 13:25:08 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted et al.

I've only just noticed this, so I have no idea how long it has been this way.

When I build a kernel with CONFIG_EXT4_USE_FOR_EXT23=y and boot from it,
the ext4 root filesystem shows up as "ext2" mode, rather than "ext4".

This looks very wrong to me, and quite dangerous.

Eg.  I test it by building my own kernel (2.6.38.2), with ext4 built-in,
no initramfs required, and boot:

    root=/dev/sda1 init=/bin/bash
    ...
    $ mount /proc
    $ cat /proc/mounts
    /dev/root / ext2 ro,relatime,barrier=1,data=ordered 0 0

So.. it shows "ext2" instead of "ext4".  That really looks like a bug.
Especially since it appears to be using journaling regardless.

Building the kernel without CONFIG_EXT4_USE_FOR_EXT23
results in a proper "ext4" mount entry in /proc/mounts.

