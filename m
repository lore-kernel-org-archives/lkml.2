Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab2IDQ3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:29:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45117 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086Ab2IDQ3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:29:47 -0400
Date: Tue, 4 Sep 2012 11:13:30 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, kernel-janitors@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] tpm: fix tpm_acpi sparse warning on different address
 spaces
Message-ID: <20120904161330.GA20588@linux.vnet.ibm.com>
References: <20120830143839.GA9589@linux.vnet.ibm.com>
 <20120830174556.GD20741@mwanda>
 <20120830192155.GA25524@linux.vnet.ibm.com>
 <20120902163030.GB1840@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120902163030.GB1840@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090416-7182-0000-0000-0000027CDBC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 09:30:30AM -0700, Dan Carpenter wrote:
> Sparse finds that bug as well.  ;)
> 
> drivers/acpi/acpica/tbfadt.c:247:15: warning: incorrect type in assignment (different address spaces)
> drivers/acpi/acpica/tbfadt.c:247:15:    expected struct acpi_table_header *table
> drivers/acpi/acpica/tbfadt.c:247:15:    got void [noderef] <asn:2>*
> drivers/acpi/acpica/tbfadt.c:266:30: warning: incorrect type in argument 1 (different address spaces)
> drivers/acpi/acpica/tbfadt.c:266:30:    expected void [noderef] <asn:2>*logical_address
> drivers/acpi/acpica/tbfadt.c:266:30:    got struct acpi_table_header *table
> 
> It should be memcpy_fromio() probably.

  Thanks Dan, that's clearly better. James, I'll resubmit this one
today.

Thanks,
Kent

