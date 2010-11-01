Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab0KAFeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 01:34:37 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:42782 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752664Ab0KAFee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 01:34:34 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: fs: inode freeing and hash lookup via RCU
Date: Mon,  1 Nov 2010 16:33:41 +1100
Message-Id: <1288589624-15251-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

The following three patches implement the extra functionality you
wanted on top of the inode lock breakup. The first patch lifts the
i_lock up out of writeback_single_inode(), the second implements RCU
freeing of inodes via SLAB_DESTROY_BY_RCU, and the third converts
inode hash lookup operations to use RCU list walks. Comments are
welcome.

Cheers,

Dave.
