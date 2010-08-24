Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab0HXLHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:07:46 -0400
Received: from 78-86-195-86.zone2.bethere.co.uk ([78.86.195.86]:56944 "EHLO
	sentinel1.shatteredsilicon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751207Ab0HXLHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:07:44 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 07:07:43 EDT
Message-ID: <4C73A617.7010201@bobich.net>
Date: Tue, 24 Aug 2010 11:59:35 +0100
From: Gordan Bobic <gordan@bobich.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Documentation on Replacement of Deprecated O_SYNC_* FS flags/calls
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to port e2compr patches to 2.6.35.2, and I've run into the 
following issue. The code here, that I need to patch into fs/ext2/file.c:

=============
if (status >= 0) {
	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
		if (ei->i_compr_flags & EXT2_OSYNC_INODE) {
			osync_already = 1;
		} else {
			osync_already = 0;
			ei->i_compr_flags |= EXT2_OSYNC_INODE;
		}

		/* Should 2nd arg be inode->i_mapping? */
		status = generic_osync_inode(inode, file->f_mapping,
			OSYNC_METADATA|OSYNC_DATA);
		if (osync_already == 0) {
			ei->i_compr_flags &= ~EXT2_OSYNC_INODE;
		}
	}
}
=============

uses the deprecated O_SYNC_* flags that have been deprecated and removed 
around the 2.6.31 era. Is there any documentation available on the new 
way this should be done?

Many thanks.

Gordan
