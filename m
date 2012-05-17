Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965754Ab2EQD4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:56:06 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:63826 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933450Ab2EQD4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:56:03 -0400
Message-ID: <4FB476CA.70404@suse.com>
Date: Wed, 16 May 2012 20:55:54 -0700
From: Lee Duncan <lduncan@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kai.makisara@kolumbus.fi, jeffm@suse.com
Subject: [PATCH 0/5] st: patches to increase max number of tapes beyond 128
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set increases the maximum number of tape drives.  The device
limit of 128 tape drives was established in 2003 as a significant increase
from the 8 tape drives allowed previously.

We have seen many Linux sites that, between a large number of tape drives
and multipathing, are discovering more than 128 devices and are running
into problems.

This patch set cleans up some st code that made increasing the number
of drives costly, then actually increases the maximum number from 128
to 2^17 devices (based on the current code).

Jeff Mahoney (5):
  st: Use static class attributes
  st: clean up dev cleanup in st_probe
  st: get rid of scsi_tapes array
  st: clean up device file creation and removal
  st: raise device limit

 drivers/scsi/st.c |  404 ++++++++++++++++++++++-------------------------------
 drivers/scsi/st.h |    4 +-
 2 files changed, 169 insertions(+), 239 deletions(-)

-- 
1.7.9.2

