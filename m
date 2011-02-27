Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab1B0VVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 16:21:45 -0500
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:60749 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1B0VVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 16:21:44 -0500
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linux-kernel@vger.kernel.org
Cc: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
Subject: [PATCH 0/2] x86_32 cleanup: KERNEL_IMAGE_SIZE
Date: Sun, 27 Feb 2011 23:21:36 +0200
Message-Id: <1298841698-31823-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.4.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Sun, 27 Feb 2011 23:21:43 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that KERNEL_IMAGE_SIZE is no longer used by x86_32 code
(head_32.S no longer uses it for the initial kernel mapping).

We can thus remove the assert from the vmlinux.lds.S file, and 
remove it completely for x86_32 code. 

Since head_32.S doesn't use it anymore, I can't find a reason 
why we should impose such a limit on the kernel image size
(although a 512+MB kernel image isn't what one would call a realistic
scenario :P)

I think that a limit on the size of the image is imposed anyway
by decompress_kernel()(if I understood correctly).

I also updated the comments in head_32.S which still had references
to KERNEL_IMAGE_SIZE.
