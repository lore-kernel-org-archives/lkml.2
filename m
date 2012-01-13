Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab2AMByD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:54:03 -0500
Received: from alcazar.beanwood.com ([70.85.129.230]:39746 "EHLO
	alcazar.beanwood.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab2AMBxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:53:55 -0500
From: Andrew Ayer <agwa@andrewayer.name>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2 RESEND] POSIX-compliant version of fchmodat with flag argument
Date: Thu, 12 Jan 2012 17:53:44 -0800
Message-Id: <1326419626-22568-1-git-send-email-agwa@andrewayer.name>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The below patches implement a 4 argument version of fchmodat (fchmodat4)
that has a flag argument, as specified by POSIX.  This is needed to
implement a proper glibc wrapper.

fchmodat4 supports the same two flags as fchownat: AT_SYMLINK_NOFOLLOW
and AT_EMPTY_PATH.

Besides the POSIX-compliance, this patch will make it possible to
ensure, in a race-free way, that you do not follow symlinks when
chmodding. Previously, you could open a file with O_NOFOLLOW and fchmod
it, but this only worked if you had read or write permissions on the
file.  Now you can open the file with O_PATH|O_NOFOLLOW and do fchmodat
with AT_EMPTY_PATH.

Could this patch be applied?  Any feedback is welcome.

Cheers, 
Andrew
