Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab2KTOjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:39:12 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:40642 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KTOjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:39:10 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 0/2] RFC only - allow arches to over-ride unit sized user copies
Date: Tue, 20 Nov 2012 20:08:15 +0530
Message-ID: <1353422297-29079-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Hi Arnd,

The current asm-generic/uaccess unit copy interface __{get,put}_user( )
defaults to using __copy_{to,from}_user( ). For archs which don't support
unaligned access, latter typically involves generated code for alignment
checks.

It is expected that arch will provide a fast path in __copy_{to,from}_user( )
for such unit sized copies - probably using __builtin_const_p( ) etc -
however the alignment checks still can't be eliminated altogether using that.
Even if they could, it woudl make the implementation messier IMHO.

However given that 2 separate interfaces already exist form beginning
(i.e. __get_user vs. __copy_from_user) will it make sense to allow arch to
provide alternate implementation of former w/o having to mess with latter.

I did a quick hack to that end and I can see that savings are more than
just "noise".

bloat-o-meter vmlinux_pre_uaccess vmlinux_uaccess_part1 | head
add/remove: 0/1 grow/shrink: 10/62 up/down: 1502/-7256 (-5754)

The patch which converts just __get_user follows. I've not
done the full/clean version yet as this is just to gather feedback.

Thx,
-Vineet

Vineet Gupta (2):
  asm-generic: uaccess: allow arch to over-ride __get_user_fn()
  ARC: provide optimal __get_user_fn()

 arch/arc/include/asm/uaccess.h |   51 ++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/uaccess.h  |    5 ++++
 2 files changed, 56 insertions(+), 0 deletions(-)

-- 
1.7.4.1

