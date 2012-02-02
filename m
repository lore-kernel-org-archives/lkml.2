Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2BBP16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:27:58 -0500
Received: from mx2.netapp.com ([216.240.18.37]:1127 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126Ab2BBP15 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:27:57 -0500
X-IronPort-AV: E=Sophos;i="4.71,609,1320652800"; 
   d="scan'208";a="621835607"
From: "Moger, Babu" <Babu.Moger@netapp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: device-mapper development <dm-devel@redhat.com>
Subject: [PATCH] scsi : Adding all the definitions of host bytes in
 hostbyte_table
Thread-Topic: [PATCH] scsi : Adding all the definitions of host bytes in
 hostbyte_table
Thread-Index: AczhvzhobP9uYvUISGe8E3SIK+y9MA==
Date: Thu, 2 Feb 2012 15:27:50 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B01034E@SACEXCMBX02-PRD.hq.netapp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.53]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 02 Feb 2012 15:27:52.0218 (UTC) FILETIME=[3A6DCFA0:01CCE1BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitting it again(Probably last one had some format issues).
Adding all the definitions of host bytes in hostbyte_table.

Without this patch, scsi_show_result prints hostbyte as invalid
for statuses that are not defined in hostbyte_table(when scsi logging is enabled).

Look at scsi_print_result function for better understanding.

Signed-off-by: Babu Moger <babu.moger@netapp.com>
---
--- linux-3.1-rc4/drivers/scsi/constants.c.orig	2012-01-12 15:21:28.000000000 -0600
+++ linux-3.1-rc4/drivers/scsi/constants.c	2012-01-12 15:25:07.000000000 -0600
@@ -1422,7 +1422,8 @@ static const char * const hostbyte_table
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
-"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST" };
+"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST", "DID_TARGET_FAILURE",
+"DID_NEXUS_FAILURE" };
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 static const char * const driverbyte_table[]={


