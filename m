Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2H3RqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:46:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28698 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2H3RqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:46:12 -0400
Date: Thu, 30 Aug 2012 10:45:56 -0700
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] tpm: fix tpm_acpi sparse warning on different address
 spaces
Message-ID: <20120830174556.GD20741@mwanda>
References: <20120830143839.GA9589@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830143839.GA9589@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 09:38:41AM -0500, Kent Yoder wrote:
> acpi_os_map_memory expects its return value to be in the __iomem address
> space. Cast it back later when used in a memcpy to avoid the same sparse
> warning there.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>

I can't download linux-next right now but I don't think this is the
correct fix.  I don't think you can memcpy() directly from __iomem.
The static checker is warning about a valid bug which should be
addressed instead of just casted away and silenced.

regards,
dan carpenter


