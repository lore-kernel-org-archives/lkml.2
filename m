Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0EaL2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 07:28:21 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:33099 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab0EaL2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 07:28:19 -0400
Date: Mon, 31 May 2010 13:28:18 +0200
From: Christof Schmitt <christof.schmitt@de.ibm.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Wrong DIF guard tag on ext2 write
Message-ID: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running tests with an ext2 filesystem on a device using DIF/DIX
integrity data, i sometimes see invalid guard tags on write requests.
To track down the problem, i patched the function sd_prep_fn in sd.c
to verify the IP checksums in the guard tags against the actual data.
Sometimes there is a mismatch and the write request fails when the HBA
checks the guard tag.

Since the guard tags are created in Linux, it seems that the data
attached to the write request changes between the generation in
bio_integrity_generate and the call to sd_prep_fn.

Using ext3 or ext4 instead of ext2 does not show the problem.

There is a bugzilla open at Redhat with the same symptom, but there is
no data or activity:
https://bugzilla.redhat.com/show_bug.cgi?id=574266

What would be the best way to track down this problem?

--
Christof Schmitt
