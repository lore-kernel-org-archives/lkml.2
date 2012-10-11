Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab2JKKcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:32:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53476 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464Ab2JKKc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:32:26 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Andy Whitcroft <apw@canonical.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] efivarfs: fixes and cleanups
Date: Thu, 11 Oct 2012 11:32:16 +0100
Message-Id: <1349951541-20498-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349416496.810727.310563927016.1.gpush@pecola>
References: <1349416496.810727.310563927016.1.gpush@pecola>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have recently been looking to backport the efivarfs support as posted,
to 3.5.x.  Inspired by some searching questions from Tetsuo Handa I have
been reviewing this code.  The following a first pass at fixing up some
of the error handling.  As they represent error paths they are hard to
truly verify so deserve review.

On top of 7b218e8e5d433fc8b531ce911926e06de3e6f1f6 in Matt Flemmings efi.git
repo.

-apw

Andy Whitcroft (5):
  efivarfs: efivarfs_file_read ensure we free data in error paths
  efivarfs: efivarfs_create() ensure we drop our reference on inode on error
  efivarfs: efivarfs_fill_super() fix inode reference counts
  efivarfs: efivarfs_fill_super() ensure we free our temporary name
  efivarfs: efivarfs_fill_super() ensure we clean up correctly on error

 drivers/firmware/efivars.c |   56 +++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 21 deletions(-)

-- 
1.7.9.5

