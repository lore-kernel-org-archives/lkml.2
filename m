Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab1FJALH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 20:11:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972Ab1FJALF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 20:11:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110609214241.GA4849@sepie.suse.cz>
References: <20110609214241.GA4849@sepie.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Jun 2011 17:10:12 -0700
Message-ID: <BANLkTim84t=yeqykZydEjHrVYGnO4xc5ew@mail.gmail.com>
Subject: Re: [GIT] kbuild fixes for 3.0
To: Michal Marek <mmarek@suse.cz>
Cc: pefoley2@verizon.net, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 2:42 PM, Michal Marek <mmarek@suse.cz> wrote:
>
>      kbuild: Hack for depmod not handling X.Y versions

This doesn't seem to be enough, I still get (on F-14):

  sh /home/torvalds/v2.6/linux/arch/x86/boot/install.sh
3.0-rc2-00251-g7f45e5cd1718-dirty arch/x86/boot/bzImage \
  	System.map "/boot"
  WARNING: Couldn't open directory
/tmp/initramfs.Z9p0zm/lib/modules/3.0.0-rc2-00191-g4c1f683a4a34-dirty:
No such file or directory
  FATAL: Could not open
/tmp/initramfs.Z9p0zm/lib/modules/3.0.0-rc2-00191-g4c1f683a4a34-dirty/modules.dep.temp
for writing: No such file or directory
  E: "depmod -a 3.0-rc2-00251-g7f45e5cd1718-dirty" failed.

from "make install" when I try to remove the SUBLEVEL.

As a result, the initrd is unusable, and has no modules in it.

                Linus
