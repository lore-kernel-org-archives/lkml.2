Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab1LHJf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:35:59 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:64379 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1LHJfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:35:53 -0500
From: annie.li@oracle.com
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org, paul.durrant@citrix.com,
        Ian.Campbell@citrix.com
Cc: kurt.hackel@oracle.com, annie.li@oracle.com
Subject: [PATCH V2 0/2] xen: patches for supporting sub-page and transitive grants
Date: Thu,  8 Dec 2011 17:35:40 +0800
Message-Id: <1323336940-5382-1-git-send-email-annie.li@oracle.com>
X-Mailer: git-send-email 1.7.6.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A02020B.4EE084F4.00C4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Following two patches introduce and implement interfaces for sub-page and transitive grants, and they are based on linux-next branch of linux/kernel/git/konrad/xen.git(3.2.0-rc2+). Sub-page and transitive grants are new types of grant table V2.

Descriptions for those patches:

Through sub-page grant table interfaces, a domain can grant another domain access to a range of bytes within a page, and Xen will then prevent the grantee domain accessing outside that range.  For obvious reasons, it isn't possible to map these grant references, and domains are expected to use the grant copy hypercall instead.

Through transitive grant interfaces,  a domain can create grant reference which redirects to another grant reference, so that any attempt to access the first grant reference will be redirected to the second one.  This is used to implement receiver-side copy on inter-domain traffic: rather than copying the packet in dom0, dom0 creates a transitive grant referencing the original transmit buffer, and passes that to the receiving domain.

Annie Li (2):
  xen/granttable: Support sub-page grants
  xen/granttable: Support transitive grants

 drivers/xen/grant-table.c |  147 +++++++++++++++++++++++++++++++++++++++++++++
 include/xen/grant_table.h |   25 ++++++++
 2 files changed, 172 insertions(+), 0 deletions(-)

Thanks
Annie

-- 
1.7.6.4

