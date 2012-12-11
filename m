Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2LKSEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:04:45 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10061 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab2LKSEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:04:42 -0500
Message-ID: <50C775AB.70706@parallels.com>
Date: Tue, 11 Dec 2012 22:04:27 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        CRIU <criu@openvz.org>
CC: "users@openvz.org" <users@openvz.org>
Subject: [Announce] Checkpoint-restore tool v0.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The Linux-v3.7 is out, and it's good time to release the next version
of the checkpoint-restore tool.

This is mostly bugfix and improvements release, however it's worth
mentioning some new interesting features

  * Proper COW mappings handling
    Now anonymous private mappings are not COW-ed at restore, but
    pages that were shared remain such [1]

  * Full support for PF_PACKET sockets, thus letting us to C/R the
    tcpdump tool

  * The --shell-job option, which makes it possible to dump apps
    launched from one shell and restore them in another [2]

Some features are still available with the custom kernel, but things
are eventually getting merged upstream. In particular the 3.7 now has
support for C/R-ing of LXC containers' network devices, the initial
support for packet sockets and a couple of fixes for TCP repair code.


The v0.3 can be downloaded from
http://download.openvz.org/criu/crtools-0.3.tar.bz2
The project home is at http://criu.org

[1] https://plus.google.com/103175467322423551911/posts/bkgqbGTHfSt
[2] https://plus.google.com/103175467322423551911/posts/AYEu9w5HXiH

Thanks,
Pavel
