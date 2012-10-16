Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2JPJQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:16:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44255 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2JPJQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:16:45 -0400
Message-ID: <507D25F5.3030001@canonical.com>
Date: Tue, 16 Oct 2012 17:16:37 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] efivarfs: efivarfs_fill_super() ensure we clean up
 correctly on error
References: <1349416496.810727.310563927016.1.gpush@pecola> <1349951541-20498-1-git-send-email-apw@canonical.com> <1349951541-20498-6-git-send-email-apw@canonical.com> <5076D1EC.1060100@canonical.com> <20121011160633.GA23494@dm>
In-Reply-To: <20121011160633.GA23494@dm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

>> If we break out of the loop on the second (and onwards) iteration,
>> won't we still have the other inodes and dentries remaining
>> allocated?
>
> As we calling this from the mount_single() wrapper:
>
>          return mount_single(fs_type, flags, data, efivarfs_fill_super);
>
>
> which does this:
>
>      struct dentry *mount_single(struct file_system_type *fs_type,
> 	    int flags, void *data,
> 	    int (*fill_super)(struct super_block *, void *, int))
>      {
>      [...]
> 		    error = fill_super(s, data, flags & MS_SILENT ? 1 : 0);
> 		    if (error) {
> 			    deactivate_locked_super(s);
> 			    return ERR_PTR(error);
> 		    }
>      [...]
>
> I am expecting us to get called back via deactivate_locked_super(),
> which calls sb->kill_sb() which is:
>
>      static void efivarfs_kill_sb(struct super_block *sb)
>      {
> 	    kill_litter_super(sb);
> 	    efivarfs_sb = NULL;
>      }
>
> Which I believe will clean them up.

Awesome, thanks for that. Looks good to me.

Acked-by: Jeremy Kerr <jeremy.kerr@canonical.com>

Cheers,


Jeremy Kerr

