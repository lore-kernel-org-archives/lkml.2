Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab1E3NNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:13:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63233 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1E3NNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JDvw/zNOhgWxaJxUN5jZCrHSo9q9+ys9lGgieGIKtwa4DYB0kiGk/5Bq+31f8Ve9qj
         j5b6GqhCBCCUwEFC3MMQlaR8xKeUYu4vWxRyfduNPmhjDnPxhZVjdOEsAs4JFuygOzKu
         ynCZSJ24klXbNnfcP+CuJH6MCKOcmeO7NRKP8=
MIME-Version: 1.0
Date: Mon, 30 May 2011 10:13:52 -0300
Message-ID: <BANLkTim2Fc44BvYDkFqWMdphjeoJZf6cAQ@mail.gmail.com>
Subject: inodes: df -i vs /proc/sys/fs/inode-nr
From: Marco Shaw <marco.shaw@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I've tried, but failed to find this answer elsewhere, or at least a
definite answer, without trying to look at the source code.)

Is there anything online that contrasts what "df -i" reports and the
values provided by /proc/sys/fs/inode-nr?  Is there a connection?  I
have a decent grasp on VFS-related "inodes" on disk, but inode-nr
reports "in-memory inodes"(?), and I don't understand what that means.

For a particular system, for example, df -i reports 1% to 4% inode
utilization for different FSs, while /proc/sys/fs/inode-nr reports 70%
(even 100% at some point) used (see Note 1 below).

For example, what happens when the inode-nr reports 100% used on a
system?  I opened a support case with my vendor, and at one point an
engineer indicates that "if inode-nr reports 100% utilization, there
could be all kinds of problems", but then another engineer goes on to
indicate something along the lines that "with kernel 2.6, this is no
longer a problem and the kernel will dynamically adjust the maximum".

So, should I monitor /proc/sys/fs/inode-nr?  Should I only monitoring
it on 2.4.x because it is "meaningless" (or at least not a cause of
concern) on 2.6.x?

Marco

Note 1: inode_used_percent = 100*(inode_alloc - inode_free)/inode_alloc
