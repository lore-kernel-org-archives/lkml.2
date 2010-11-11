Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab0KKRJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:09:22 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:41808 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754982Ab0KKRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:09:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nE0lATE9Wdaxs1cq0/zP6jKUZSVSER0iyGfiBGASf/DifJtVnBpvmgR9U8QX+8Fhw3amuPltXcAbI3qPUgeY3jd7sHNOURl6TjZofBkrYEfcare+VwuHMwTAnqgLS4ZT;
Date: Thu, 11 Nov 2010 09:09:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chandru Siddalingappa <chandru@linux.vnet.ibm.com>
Subject: Re: [PATCH] PCI hotplug: ibmphp: Add check to prevent reading
 beyond mapped area
Message-ID: <20101111090912.7ae22625@jbarnes-desktop>
In-Reply-To: <1289276427.12418.86.camel@gandalf.stny.rr.com>
References: <1289276427.12418.86.camel@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Nov 2010 23:20:27 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> While testing various randconfigs with ktest.pl, I hit the following panic:
> 
> BUG: unable to handle kernel paging request at f7e54b03
> IP: [<c0d63409>] ibmphp_access_ebda+0x101/0x19bb
> 
> Adding printks, I found that the loop that reads the ebda blocks
> can move out of the mapped section.
> 
> ibmphp_access_ebda: start=f7e44c00 size=5120 end=f7e46000
> ibmphp_access_ebda: io_mem=f7e44d80 offset=384
> ibmphp_access_ebda: io_mem=f7e54b03 offset=65283
> 
> The start of the iomap was at f7e44c00 and had a size of 5120,
> making the end f7e46000. We start with an offset of 0x180 or
> 384, giving the first read at 0xf7e44d80. Reading that location
> yields 65283, which is much bigger than the 5120 that was allocated
> and makes the next read at f7e54b03 which is outside the mapped area.
> 
> Perhaps this is a bug in the driver, or buggy hardware, but this patch
> is more about not crashing my box on start up and just giving a warning
> if it detects this error.
> 
> This patch at least lets my box boot with just a warning.
> 
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Chandru Siddalingappa <chandru@linux.vnet.ibm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> ---
>  drivers/pci/hotplug/ibmphp_ebda.c |    6 ++++++
>  1 file changed, 6 insertions(+)

Applied to my for-linus branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
