Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab1I3N7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:59:02 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:58491 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab1I3N7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:59:00 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Apple Message framework v1244.3)
Subject: CIFS  kernel module bug
From: Anton Altaparmakov <aia21@cam.ac.uk>
Date: Fri, 30 Sep 2011 14:58:58 +0100
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
To: Steve French <sfrench@samba.org>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looking at the current kernel (in Linus' repository on github) there is a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_llseek() there is this bit of code:

	/*
	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
	 * the cached file length
	 */
	if (origin != SEEK_SET || origin != SEEK_CUR) {

The logical or should be a logical and, i.e. this should be:

	if (origin != SEEK_SET && origin != SEEK_CUR) {

As the code is at present that line is ALWAYS true because origin is ALWAYS either != SEEK_SET or != SEEK_CUR as if it equals one it cannot equal the other and vice versa…

So at the moment it always does the revalidation instead of only for SEEK_END, SEEK_DATA, and SEEK_HOLE.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

