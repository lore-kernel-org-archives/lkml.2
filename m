Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab2HHQ5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:57:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39833 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab2HHQ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:57:50 -0400
Date: Wed, 8 Aug 2012 19:57:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: manish.rangankar@qlogic.com, open-iscsi@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [SCSI] qla4xxx: support iscsiadm session mgmt
Message-ID: <20120808165712.GB3734@mwanda>
References: <20120614182745.GA6383@elgon.mountain>
 <20120808150022.GA3734@mwanda>
 <50228750.3030108@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50228750.3030108@cs.wisc.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 10:35:44AM -0500, Mike Christie wrote:
> On 08/08/2012 10:00 AM, Dan Carpenter wrote:
> > I never heard back on this.  This buffer overflow is still present
> > in the current code.
> > 
> 
> Qlogic just sent a patch yesterday.
> http://marc.info/?l=linux-scsi&m=134434199930938&w=2

Ah, good.

It seems like qla4xxx_ep_connect() should take a pointer to struct
sockaddr_storage and also dst_addr in qla4xxx_get_ep_fwdb() should
be changed as well.  As in:

 static struct iscsi_endpoint *
-qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
+qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr_storage *dst_addr,
                    int non_blocking)

regards,
dan carpenter
