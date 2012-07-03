Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2GCTGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:06:14 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:48218 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab2GCTGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:06:12 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=from:message-id;
	b=60UahVZGTHOQ+YxeWQ0ufbdLv34cEpTrN5Iojmw1qabXt0W3M+b94Z7DNvTC
	3Z7l1yNHO99kuqd3MYTJxppVdyChqwXNXmfjC5kd+lFvUTrVaqnW5BHEq
	TISVHJub+aLwlaUDvaxfLfgVE2N9WasKiZ02LSbKqQSMVJUlvtYXLg=;
X-Spam-Processed: mail.digidescorp.com, Tue, 03 Jul 2012 14:06:10 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1531cb781b=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] fat (exportfs): fix NFS file handle decode
Date: Tue,  3 Jul 2012 14:06:03 -0500
Message-Id: <1341342365-15290-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system evicts inodes and dentries under memory pressure, the FAT
driver is unable to map NFS file handles back to the objects they reference.
In many cases this causes client operations to fail with ENOENT. This is
partially due to ineffectiveness of the current FAT NFS implementation,
and partially due to export_operations that have not yet been implemented for
FAT. For example, the lack of a fh_to_parent method can cause file accesses to
fail on shares exported with subtree_check.

This series depends on the following patches:
* fat: Fix non-atomic NFS i_pos read
* fat: Accessors for msdos_dir_entry 'start' fields
* fat: Refactor shortname parsing


