Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab2JDJI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:08:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51220 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2JDJI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:08:57 -0400
Message-ID: <506D5220.8080307@canonical.com>
Date: Thu, 04 Oct 2012 17:08:48 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, glin@suse.com,
        "Lee, Chun-Yi" <jlee@suse.com>, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] efi: add efivars kobject to efi sysfs folder
References: <1349317486-30006-1-git-send-email-jlee@suse.com> <1349340875.15966.18.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1349340875.15966.18.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

> Jeremy, did you want to pick this up as part of your series?

I have this in my series, yes. I'm just working on the authenticated 
delete code, then will send out the next revision.

Speaking of which - Peter: I've realised that doing a GetVariable() 
after the SetVariable is a much cleaner way of checking whether we need 
to drop the inode after an authenticated delete.

Because the inode's size may not be simply updated by the write(), we 
should probably be doing a GetVariable() after an APPEND_WRITE, to read 
the new size. Rather than having a separate (and quite complex) code 
path to check for the delete case, we may as well use the same logic to 
determine if the variable has been deleted.

> Actually, shouldn't the new filesystem be called "efivarfs", or "efifs"
> to make it more explicit that it is a filesystem?

I'm not too fussed about the name, but +1 for efivarfs.

> We also need something in Documentation/filesystems/ describing the old
> EFI variable method, why it's no longer any good, and why the new
> filesystem is favoured. Does anybody have anything to add to the
> following?

Looks good to me. We can always elaborate later, if necessary.

Cheers,


Jeremy

