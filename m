Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab0LPSCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:02:37 -0500
Received: from mail-ww0-f66.google.com ([74.125.82.66]:36637 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab0LPSCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Qx668iEIvrcc0PpTo8hUmwOuItGpeZ1sF8slPqN54K1DnLBjDIeh154TGJiqsKupMr
         0tc3vfiB+tZ48EWfBJDARbNfjJ0orGvvuiOrsffu0FWAEVzAGLANJ1p/XE2flzIKu7yR
         X+bgG9f4eyTA+JKB88mB1vmdJCgbvuUsr93WI=
Message-ID: <4D0A536A.9050800@gmail.com>
Date: Thu, 16 Dec 2010 18:59:06 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/16 v5] pramfs: persistent and protected RAM filesystem
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

fifth round for the patch series. I summarize here the changes to
improve the review:

v5:
- removed the changelog from documentation file
- added the function pram_check_flags in the file operations
- added a check when the user uses XIP and the blocksize is different
from page size
- added i_meta_mutex to avoid race conditions in the inode update
path
- changed the lock policy during mem{lock|unlock} operations
- replaced bitmap_set with bitmap_fill
- added mount options xip, acl, noacl, noprotect, user_xattr and
nouser_xattr as required by Paul Maundt
- inserted pr_fmt in pram.h
- inserted macros IF2DT and DT2IF
- removed file name description from each file
- used min_t instead of using own check in pram_add_link()

v4:
- in bitmap init used already present bitmap_set function
- fix a possible memory leak in an error path reported by yidong zhang

v3:
- fix a possible memory leak in an error path reported by yidong zhang
- fix a warning when using XIP about not used __pram_mmap symbol
- fix test module header description and replaced TEST_MODULE with
PRAMFS_TEST_MODULE in the Kconfig and Makefile according to the comments
done by Randy Dunlap
- fix a compilation warning in super.c reported by James Hogan
- fix a compilation error when XIP was enabled
- removed not used symbol PRAM_XATTR_INDEX_LUSTRE
- fix some comment style issue

v2:
- fix documentation errors reported by Randy Dunlap and Kieran Bingham
- reworked memory write protection functions with the suggestions of
Andi Kleen

v1:
- first draft

Marco
