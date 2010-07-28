Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0G1ROO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:14:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44568 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab0G1ROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CXnCgEfmC7Ta1UlvxZNej5m3ImNzdwq/u1s1pKK2N9PPB5ZMk55LkgbwUK4oFffAFM
         YAFT1vGLETw/wp+XWAA8szlyq9eVPDJUzK2km00pN7AsKmt8i4oPR9QRw/RA1Vilifu3
         h2tlOjFUg51iKQJHvx7W/531kx8j8xpM7bFms=
Date: Wed, 28 Jul 2010 21:13:27 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] x86: mce: fix error handling
Message-ID: <20100728171327.GA24149@albatros>
References: <1280335185-23265-1-git-send-email-segooon@gmail.com>
 <4C5063D4.4070108@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5063D4.4070108@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 28, 2010 at 19:07 +0200, Andi Kleen wrote:
>  On 7/28/2010 6:39 PM, Kulikov Vasiliy wrote:
> >mcheck_init_device() poorly handles errors. If any request fails
> >unregister and free everything.
> 
> Actually these are at early boot time and only contain memory errors,
> and if you run out of memory at this stage the system is usually
> dead in the water anyways. The best you can do at this stage
> is panicing, but silently returning from the the init function doesn't
> help anyone. But someone else will likely panic anyways.
> 
> e.g. boot time allocations of cpu masks generally do not check for memory
> failures and I think that's ok, not a bug.
> 
> Your patch would be good if the driver was modular, but it isn't.

I'm agree with you that if allocation fails at boot time, we are dead :)
But this coding style breaking rules that result from some functions
_must_ be checked for errors. Maybe we should add BUG_ON() here or
indicate someway that we have no ideas how to handle error?
