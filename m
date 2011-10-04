Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab1JDPEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:04:36 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:45532 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932431Ab1JDPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:04:35 -0400
Date: Tue, 4 Oct 2011 11:04:17 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Message-ID: <20111004150417.GA23604@elliptictech.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003073203.GA22694@in.ibm.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-03 13:02 +0530, K.Prasad wrote:
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 08363b0..483b2fc 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -238,6 +238,34 @@ static atomic_t mce_paniced;
>  static int fake_panic;
>  static atomic_t mce_fake_paniced;
>  
> +void arch_add_nocoredump_note(u32 *buf)
> +{
> +	struct elf_note note;
> +	const char note_name[] = "PANIC_MCE";

        static const ...

> +	const char desc_msg[] = "Crash induced due to a fatal machine "
> +				"check error";

        likewise.

Please don't break string literals onto multiple lines like this, since
it prevents users from finding the string using "grep".

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
