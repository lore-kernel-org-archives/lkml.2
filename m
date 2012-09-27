Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab2I0Rnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:43:41 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46149 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2I0Rnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:43:39 -0400
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH scsi] Short the path length of scsi_cmd_to_driver()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1348464626.2475.13.camel@ThinkPad-T420>
	<1348465493.2467.3.camel@dabdike>
	<1348470210.2475.47.camel@ThinkPad-T420>
	<1348472104.2467.8.camel@dabdike> <yq13924b4uw.fsf@sermon.lab.mkp.net>
	<1348721055.2509.0.camel@dabdike>
	<1348739495.3596.55.camel@ThinkPad-T420>
Date: Thu, 27 Sep 2012 13:43:18 -0400
In-Reply-To: <1348739495.3596.55.camel@ThinkPad-T420> (Li Zhong's message of
	"Thu, 27 Sep 2012 17:51:35 +0800")
Message-ID: <yq1a9wb8iq1.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Li" == Li Zhong <zhong@linux.vnet.ibm.com> writes:

> @@ -845,8 +844,11 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
> 
> 	scsi_eh_restore_cmnd(scmd, &ses);
> 
>-	if (sdrv && sdrv->eh_action)
>-		rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
>+	if (scmd->request->cmd_type == REQ_TYPE_FS) {
>+		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>+		if (sdrv->eh_action)
>+			rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
>+	}
> 
> 	return rtn;
> }

My only concern is whether our device lifetime rules guarantee that the
ULD is always attached when we service an error handling command?

-- 
Martin K. Petersen	Oracle Linux Engineering
