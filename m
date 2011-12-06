Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252Ab1LFKxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:53:41 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:36821 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118Ab1LFKxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:53:39 -0500
Message-ID: <4EDDF41E.8070200@oracle.com>
Date: Tue, 06 Dec 2011 18:53:18 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Paul Durrant <paul.durrant@citrix.com>,
        Kurt Hackel <Kurt.Hackel@oracle.com>
Subject: xen: patches for supporting sub-page and transitive grants
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4EDDF42F.0069,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Following two patches introduce and implement interfaces for sub-page 
and transitive grants, and they are based on linux-next branch of 
linux/kernel/git/konrad/xen.git(3.2.0-rc2+). Sub-page and transitive 
grants are new types of grant table V2.

Descriptions for those patches:

Through sub-page grant table interfaces, a domain can grant another 
domain access to a range of bytes within a page, and Xen will then 
prevent the grantee domain accessing outside that range.  For obvious 
reasons, it isn't possible to map these grant references, and domains 
are expected to use the grant copy hypercall instead.

Through transitive grant interfaces,  a domain can create grant 
reference which redirects to another grant reference, so that any 
attempt to access the first grant reference will be redirected to the 
second one.  This is used to implement receiver-side copy on 
inter-domain traffic: rather than copying the packet in dom0, dom0 
creates a transitive grant referencing the original transmit buffer, and 
passes that to the receiving domain.

Diff:

  drivers/xen/grant-table.c |   74 
+++++++++++++++++++++++++++++++++++++++++++++
  include/xen/grant_table.h |   19 +++++++++++
  2 files changed, 93 insertions(+), 0 deletions(-)

Shortlog:

Annie Li (2):
       xen/granttable: Support sub-page grants
       xen/granttable: Support transitive grants

Thanks
Annie
