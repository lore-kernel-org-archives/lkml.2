Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab1KVFis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:38:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33583 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1KVFir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:38:47 -0500
Date: Tue, 22 Nov 2011 13:33:43 +0800
From: wangyanqing <udknight@gmail.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "warns@pre-sense.de" <warns@pre-sense.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>, pjones@redhat.com,
        mjg59@redhat.com
Subject: Re: [PATCH] fs:partitions:efi.c: correct misuse force_gpt
Message-ID: <20111122053343.GA32343@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>,
	Matt Domsch <Matt_Domsch@dell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"warns@pre-sense.de" <warns@pre-sense.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tj@kernel.org" <tj@kernel.org>,
	"jaxboe@fusionio.com" <jaxboe@fusionio.com>, pjones@redhat.com,
	mjg59@redhat.com
References: <20111122004434.GA6584@udknight.homenetwork>
 <20111121165655.18224b14.akpm@linux-foundation.org>
 <20111122043325.GA4979@emperor.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122043325.GA4979@emperor.us.dell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:33:25PM -0600, Matt Domsch wrote:

> Again, here there is some debate, what the Alternate GPT header and
> table are good for.
> 
> I put the comment in to remind myself a decade later...
> 
> /**
>  * find_valid_gpt() - Search disk for valid GPT headers and PTEs
>  * @state
>  * @gpt is a GPT header ptr, filled on return.
>  * @ptes is a PTEs ptr, filled on return.
>  * Description: Returns 1 if valid, 0 on error.
>  * If valid, returns pointers to newly allocated GPT header and PTEs.
>  * Validity depends on PMBR being valid (or being overridden by the
>  * 'gpt' kernel command line option) and finding either the Primary
>  * GPT header and PTEs valid, or the Alternate GPT header and PTEs
>  * valid.  If the Primary GPT header is not valid, the Alternate GPT header
>  * is not checked unless the 'gpt' kernel command line option is passed.
>  * This protects against devices which misreport their size, and forces
>  * the user to decide to use the Alternate GPT.
>  */
> 
> Why is this?
> 
> There were a class of hard disks (IIRC, first generation iPods at
> least), that would report their size off by one (one sector larger
> than they actually were), and attempting to read from that one-past
> sector would cause the whole device to go catatonic, which would then
> hang the boot process.
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=281905 and what
> should be in the historical kernel tree.
> 
> Your patch undoes the patch that prevented the boot from hanging in
> such situations.
> 
> Because we can't know which disks might misbehave this way, and
> because it is a catastrophic failure when it happens, we wanted to
> force the user to do something which might cause the failure to occur,
> hence it's protected behind the force_gpt flag.
Sorry I miss the comment, and you are right!

> 
> Seconarily, the primary purpose of the AGPT in my mind is so that
> userspace tools like parted can look at all the available information
> and make a decision as to whether the AGPT info is valid and should be
> used, if the PGPT is corrupt, and then can fix up either or both
> headers as necessary.  Inside the kernel, there's very little I want
> to trust the AGPT for if I can avoid it, and nothing can fix either
> header if determined to be corrupt.
Thanks for the detail explanation! Matt


