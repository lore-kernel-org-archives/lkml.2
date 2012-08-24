Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab2HXNpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:45:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47604 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701Ab2HXNpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:45:01 -0400
Date: Fri, 24 Aug 2012 15:45:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Attilio Rao <attilio.rao@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
Message-ID: <20120824134459.GA6171@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Attilio Rao <attilio.rao@citrix.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
	Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com>
 <1345648122-11935-2-git-send-email-attilio.rao@citrix.com>
 <alpine.LFD.2.02.1208231722040.2856@ionos>
 <50364FE5.1070608@citrix.com>
 <alpine.LFD.2.02.1208231800530.2856@ionos>
 <503664C3.7010301@citrix.com>
 <20120824100309.GG3019@liondog.tnic>
 <20120824113644.GE11007@konrad-lan.dumpdata.com>
 <alpine.LFD.2.02.1208241446090.2856@ionos>
 <50378070.3000904@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50378070.3000904@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 02:24:00PM +0100, Attilio Rao wrote:
> Please stop referring to your opinion as if they are the only source
> of truth. Actually here is a matter of comparing prices. We thought
> accounting for different { start, end } was a viable option, you want
> something simpler and as a x86-maintainer you enforce your opinion
> over here. But this doesn't mean what the patch does is "wrong".

If you're adding code to x86 with no apparent reason, it is wrong, and
it is not a matter of personal opinion. And to be very specific, I mean
the hunk below.

If it doesn't fix any issue on x86 but is only for documentation, we
don't want it.

In /arch/x86/xen/ you can stick whatever crap you want and whatever
bullshit bingo you can come up with...

--
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e0e6990..f4b750d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -92,6 +92,10 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 
 void __init native_pagetable_reserve(u64 start, u64 end)
 {
+	if (start < PFN_PHYS(pgt_buf_start) || end > PFN_PHYS(pgt_buf_top))
+		panic("Invalid address range: [%#llx-%#llx] should be a subset of [%#llx-%#llx]\n",
+			start, end, (u64)PFN_PHYS(pgt_buf_start),
+			(u64)PFN_PHYS(pgt_buf_top));
 	memblock_reserve(start, end - start);
 }

-- 
Regards/Gruss,
Boris.
