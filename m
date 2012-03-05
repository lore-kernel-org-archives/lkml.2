Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab2CEOOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:14:14 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42314 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab2CEOOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:14:10 -0500
Date: Mon, 5 Mar 2012 15:13:49 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Message-ID: <20120305141349.GF1070@aftab>
References: <1330698314-9863-1-git-send-email-bp@amd64.org>
 <1330698314-9863-5-git-send-email-bp@amd64.org>
 <4F50DECB.8030200@redhat.com>
 <20120305110441.GC1070@aftab>
 <4F54A6FF.50502@redhat.com>
 <20120305124411.GD1070@aftab>
 <4F54C133.6040709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54C133.6040709@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 10:35:47AM -0300, Mauro Carvalho Chehab wrote:
> No. This is an example that you're not reading my emails:

Unfortunately, I read your emails.

> no other driver needs that. So, it is something that it is specific to
> the MCA amd64 drivers.

Let me spell it for ya: no, it's specific to x86, and not to amd64_edac.

> The other two MCA drivers are sb_edac and i7core_edac. I wrote both drivers, and they
> don't need any helper function to store strings on a temporary buffer.
> 
> Also, the edac core is not x86-specific. So, referencing to a var there (ras_agent) 
> that it is defined inside arch/x86 would break Kernel compilation on all other 
> architectures.

That's more like it.

It can be moved to an arch-agnostic place or be defined
__attribute__((weak)) in edac_core.c. Unless someone has a better idea,
of course.

[..]

> As already pointed out, you're not reading my emails. The above were at the version 1 of
> my patches, with I sent at least a month ago. Since version 2, what is proposed is to use:
> 
> TRACE_EVENT(mc_error_mce,
> 
> for MCA-based memory error events. There's also a variant for non-MCA drivers (mc_error). 
> 
> [1] http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=4eb2a29419c1fefd76c8dbcd308b84a4b52faf4d

I see at least 4 misdesigned tracepoints there:

trace_mc_out_of_range_mce
trace_mc_out_of_range
trace_mc_error_mce
trace_mc_error
...

so NACK to those.

> I also wrote on my emails that, instead of having a tracepoint
> specific for memory errors, it is possible to re-define the fields
> I've proposed to cover CPU location/socket label, and that this is
> better than folding everything into a hard-to-parse single string
> message.

No, this is repurposing the fields of memory errors, which is ugly. So, no.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
