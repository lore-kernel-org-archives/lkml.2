Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1LNSzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:55:49 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49122 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1LNSzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:55:48 -0500
Date: Wed, 14 Dec 2011 13:54:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: annie.li@oracle.com
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        jeremy@goop.org, paul.durrant@citrix.com, Ian.Campbell@citrix.com,
        kurt.hackel@oracle.com
Subject: Re: [PATCH V4 0/3] xen: patches for supporting sub-page and
 transitive grants
Message-ID: <20111214185440.GB24598@phenom.dumpdata.com>
References: <1323684792-5101-1-git-send-email-annie.li@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323684792-5101-1-git-send-email-annie.li@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4EE8F12A.007B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 06:13:12PM +0800, annie.li@oracle.com wrote:
> Hi
> 
> Following patches introduce and implement interfaces for sub-page and transitive grants, and they are based on linux-next branch of linux/kernel/git/konrad/xen.git(3.2.0-rc2+). Sub-page and transitive grants are new types of grant table V2.
> 
> Descriptions for those patches:
> 
> Through sub-page grant table interfaces, a domain can grant another domain access to a range of bytes within a page, and Xen will then prevent the grantee domain accessing outside that range.  For obvious reasons, it isn't possible to map these grant references, and domains are expected to use the grant copy hypercall instead.
> 
> Through transitive grant interfaces,  a domain can create grant reference which redirects to another grant reference, so that any attempt to access the first grant reference will be redirected to the second one.  This is used to implement receiver-side copy on inter-domain traffic: rather than copying the packet in dom0, dom0 creates a transitive grant referencing the original transmit buffer, and passes that to the receiving domain.
> 

Applied.

> Annie Li (3):
>   xen/granttable: Improve comments for function pointers
>   xen/granttable: Support sub-page grants
>   xen/granttable: Support transitive grants
> 
>  drivers/xen/grant-table.c |  190 +++++++++++++++++++++++++++++++++++++++------
>  include/xen/grant_table.h |   25 ++++++
>  2 files changed, 191 insertions(+), 24 deletions(-)
> 
> Thanks,
> Annie.
> -- 
> 1.7.6.4
