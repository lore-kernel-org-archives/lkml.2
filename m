Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0DLIC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:02:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab0DLICY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:02:24 -0400
To: Colin King <colin.king@canonical.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable 4MB page tables for Atom, work around errata AAE44
From: Andi Kleen <andi@firstfloor.org>
References: <1269271251-19775-1-git-send-email-colin.king@canonical.com>
Date: Mon, 12 Apr 2010 10:02:19 +0200
In-Reply-To: <1269271251-19775-1-git-send-email-colin.king@canonical.com> (Colin King's message of "Mon, 22 Mar 2010 15:20:51 +0000")
Message-ID: <87633xayk4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin King <colin.king@canonical.com> writes:
>  
> +static void __init check_atom(void)
> +{
> +
> +	/*
> +	 *  Disable 4MB page tables to work around Intel errata AAE44 for
> +	 *  Atom. We cannot guarantee stopping undefined processor behaviour
> +	 *  when two pageing structure translations differ with respect to
> +	 *  page frame sizes.  Hence, for Atoms we disable the PSE.
> +	 */
> +	if (boot_cpu_data.x86_model == 0x1c) {

Perhaps someone else pointed that out already, but you obviously
need to check for x86_vendor == X86_VENDOR_INTEL and x86_family == 6 too,
otherwise you'll get false positives.

Besides such workarounds are normally in arch/x86/kernel/cpu/intel.c.
bugs.c is really obsolete.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
