Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1LHOpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:45:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52749 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1LHOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:45:17 -0500
Date: Thu, 8 Dec 2011 15:45:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>,
        davej@redhat.com, axboe@kernel.dk, hpa@zytor.com,
        herbert@gondor.hengli.com.au, ying.huang@intel.com, lenb@kernel.org
Subject: Re: [PATCH 01/10] Add driver auto probing for x86 features
Message-ID: <20111208144516.GE24062@one.firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org> <1323304882-27953-2-git-send-email-andi@firstfloor.org> <20111208103540.4778b896@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111208103540.4778b896@endymion.delvare>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 10:35:40AM +0100, Jean Delvare wrote:
> > +/**
> > + * x86_match_cpu - match current CPU again an array of x86_cpu_ids
> 
> The code is actually matching the boot cpu, which isn't necessarily the
> current CPU. I think it would be better to let the caller pass a
> specific cpu as a parameter. At least the hwmon drivers would benefit
> from that. Then you can add an helper function x86_match_boot_cpu()
> calling x86_match_cpu() on &boot_cpu_data if you want.

I don't really see a point of this currently -- the udev/modprobe loading is 
global anyways.  If we really want to support asymmetric configs a lot 
more work all over the kernel is needed and this could be still
changed.
> 
> > + * @match: Pointer to array of x86_cpu_ids. Last entry terminated with
> > + *         X86_MODEL_END.
> 
> I see no such X86_MODEL_END, your loop below is instead treating entries
> with all fields set to 0 as the terminating entry (which seems
> reasonable.)

Hmm yes I ended up with {}. I'll fix the comment.

> > +#define X86_VENDOR_ANY 0xffff
> > +#define X86_FAMILY_ANY 0
> > +#define X86_MODEL_ANY  0
> 
> Are you sure family 0 or model 0 are never used, by any vendor? I

They could be, but we never match for them.

> wouldn't take the risk. What's wrong with 0xffff?

That would not allow abbreviating the entries: the C compiler
doesn't know how to fill in 0xffff automatically.

> 
> > +#define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
> 
> Might be better to set X86_FEATURE_ANY to either 10 (unused feature
> bit) or 0xffff then.

I don't think this is a problem in practice.

Thanks for the review.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
