Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab2AKI2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 03:28:51 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:20482 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab2AKI2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 03:28:50 -0500
Date: Wed, 11 Jan 2012 11:28:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: aacraid question: is maximum_num_containers supposed to be minimum?
Message-ID: <20120111082842.GA31452@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F0D4841.001E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAXIMUM_NUM_CONTAINERS is consistently used as a minimum not a maximum
so I was wondering what was up with that?  This is ancient code that
predates git.

drivers/scsi/aacraid/aachba.c
   382          if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
   383                  maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
   384          fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) * maximum_num_containers,
   385                          GFP_KERNEL);

Btw, if maximum_num_containers were really a maximum instead of minimum
then it should be unsigned.  That was what brought the code to my
attention initially.

drivers/scsi/aacraid/linit.c
  1235          if (shost->max_id < MAXIMUM_NUM_CONTAINERS)
  1236                  shost->max_id = MAXIMUM_NUM_CONTAINERS;
  1237          else
  1238                  shost->this_id = shost->max_id;

regards,
dan carpenter

