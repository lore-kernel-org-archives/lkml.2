Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab2H3RWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 13:22:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45064 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2H3RWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 13:22:54 -0400
Message-ID: <503FA15F.7070506@zytor.com>
Date: Thu, 30 Aug 2012 10:22:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [RFC,PATCH] efi: Add support for a UEFI variable filesystem
References: <1346319009.951368.767015086462.1.gpush@pecola>
In-Reply-To: <1346319009.951368.767015086462.1.gpush@pecola>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 02:30 AM, Jeremy Kerr wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> The existing EFI variables code only supports variables of up to 1024
> bytes. This limitation existed in version 0.99 of the EFI specification,
> but was removed before any full releases. Since variables can now be
> larger than a single page, sysfs isn't the best interface for this. So,
> instead, let's add a filesystem. Variables can be read, written and
> created, with the first 4 bytes of each variable representing its UEFI
> attributes. The create() method doesn't actually commit to flash since
> zero-length variables can't exist per-spec.
> 
> Updates from Jeremy Kerr <jeremy.kerr@canonical.com>.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
> RFC: With this patch, I can properly mange UEFI key databases from
> userspace. Comments welcome.
> 

Nice!

However, I have a question... rather than putting the attributes as the
first data bytes, would it be better to make it either part of the
filename (assuming there is at least one character other than / which
can be reasonably relied upon to not be part of the name); for example:

	LangCodes,BS,RT

... or ...

	LangCodes,6

	-hpa
