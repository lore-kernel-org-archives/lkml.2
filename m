Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab2IFOhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:37:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44045 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab2IFOhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:37:37 -0400
Message-ID: <5048B52A.6000602@canonical.com>
Date: Thu, 06 Sep 2012 22:37:30 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matt Domsch <Matt_Domsch@Dell.com>,
        Peter Jones <pjones@redhat.com>
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
References: <1346910035.47691.188651047712.1.gpush@pecola>  <1346941120.4244.82.camel@mfleming-mobl1.ger.corp.intel.com>  <5048B1E8.1020904@canonical.com> <1346941851.4244.87.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1346941851.4244.87.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

> I think this is the problematic chunk of code,
>
> static int efivars_unlink(struct inode *dir, struct dentry *dentry)
> {
>          struct efivar_entry *var = dentry->d_inode->i_private;
>          struct efivars *efivars = var->efivars;
>          efi_status_t status;
>
>          spin_lock(&efivars->lock);
>
>          status = efivars->ops->set_variable(var->var.VariableName,
>                                              &var->var.VendorGuid,
>                                              0, 0, NULL);
>
> For deleting authenticated variables Attributes, DataSize and Data need
> to be non-zero. I think DataSize == AuthInfo descriptor. Peter?

That's correct, but we can't use unlink to delete a secure variable, we 
need to do a write instead, in order to provide the authentication 
descriptor.

But yes, we may need to alter the efivars_file_write path so that such a 
write actually results in the dentry being removed...

Cheers,


Jeremy


