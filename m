Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2EJG7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:59:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47316 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab2EJG7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:59:32 -0400
X-AuditID: cbfee60d-b7b94ae000004ede-0f-4fab67536d40
Date: Thu, 10 May 2012 06:59:31 +0000 (GMT)
From: AMIT SAHRAWAT <a.sahrawat@samsung.com>
Subject: =?windows-1252?Q?[Problem]NFS_Server_=96_Umount_results_in_Device_Busy.?=
To: Trond.Myklebust@netapp.com
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org,
        "namjae.jeon@samsung.com" <namjae.jeon@samsung.com>
Reply-to: a.sahrawat@samsung.com
MIME-version: 1.0
X-MTR: 20120510065727517@a.sahrawat
Msgkey: 20120510065727517@a.sahrawat
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120510065727517@a.sahrawat
X-ParentMTR: 
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <32336989.330131336633170527.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4A733Sg008853

Linux Kernel: 2.6.35.14
 
We are using NFS for data transfer from one target to another target.
On Server we are using 3 mount points – to be used by application. And they are mentioned in /etc/exports
 
When initially just NFS Server is started -We can mount and safely un-mount the NFS mount point.
Now, when NFS client is started and we mount at the client. Without doing any IO – if we do un-mount at the NFS Client –it un-mounts safely.
But – when tried to un-mount the device at the NFS server – it results in error “Device Busy”
“umount: can't umount /mnt: Device or resource busy”
 
Now , in order to umount the device -  we have to kill the process ‘nfsd’ – and then it un-mounts easily.
 
As per our understanding – it should not be an issue with the un-mount when it is not being used and also there should be no dependency to kill ‘nfsd’ to un-mount the device.
 
It leads to problem of killing ‘nfsd’ and restarting it – to make other mount points work without issue.
 
Is there any method to un-mount the device without getting this ‘BUSY’ error? Or can we kill only nfsd service which was using that mount point?
Please share your input on the solution to the above problem. Is this expected behavior?
 
Thanks & Regards,
Amit Sahrawatÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
