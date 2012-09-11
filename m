Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab2IKQjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:39:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37149 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab2IKQjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:39:10 -0400
Message-ID: <504F692C.7050902@canonical.com>
Date: Tue, 11 Sep 2012 18:39:08 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: al viro <viro@zeniv.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [regression] __d_unalias() should refuse to move mountpoints
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Al,

Your vfs commit ee3efa91e240f513898050ef305a49a653c8ed90 caused my laptop
with a nfs root filesystem to stop working.

My testcase is simply booting through netboot with / and ~/nfs as separate
nfs filesystems, then doing 'ls ~/nfs' followed by 'ls ~' in a gnome-terminal
window, then I get:

ls: cannot access nfs: Device or resource busy

Similar things seem to happen with ls /, /dev /proc and /sys will no longer work.

Reverting this patch seems to make things work again.

~Maarten

