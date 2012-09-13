Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2IMINk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:13:40 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:33815 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2IMINZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:13:25 -0400
Subject: Re: Fwd: [RFC,PATCH v2] efi: Add support for a UEFI variable
 filesystem
From: joeyli <jlee@suse.com>
To: jeremy.kerr@canonical.com, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Domsch <Matt_Domsch@Dell.com>, Peter Jones <pjones@redhat.com>
In-Reply-To: <CAGLnvc9BXAW8F8WWyDxuF1_J+0np3uqUBmknuJewOJHhe-mxvw@mail.gmail.com>
References: <1346910035.47691.188651047712.1.gpush@pecola>
	 <CAGLnvc9BXAW8F8WWyDxuF1_J+0np3uqUBmknuJewOJHhe-mxvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Sep 2012 16:08:07 +0800
Message-ID: <1347523687.596.29.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 13:40 +0800, Jeremy Kerr wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> The existing EFI variables code only supports variables of up to 1024
> bytes. This limitation existed in version 0.99 of the EFI
> specification,
> but was removed before any full releases. Since variables can now be
> larger than a single page, sysfs isn't the best interface for this.
> So,
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
> v2: Add check for < 4-byte writes
> 

Do we have plan to create a new kobject add to /sys/firmware/efi for
provide a fixed mount point to efivars fs?
e.g. /sys/firmware/efi/efivars

Or we just direct reuse current /sys/firmeware/efi/vars? But, that means
we need think for the backward compatibility if choice reuse vars
folder.


Thanks a lot!
Joey Lee

