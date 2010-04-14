Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab0DMLtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 07:49:43 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62388 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0DMLtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IRZIcTUQaO0u4+swIHCan5T9De2rKFMKFEpWoKKPzcFDnKv+qs/neGFKaMFWSPtVwv
         k/QEa6h5LwpYLInWvg+WDKqiDkTX9A/BqrikLYahkL5WQedDjVsD4/OsYKyVn1LxiaoO
         7Vg1VxlVFqvHrloY/XEcLIV0uDRLQk0Yapav0=
Date: Wed, 14 Apr 2010 15:50:07 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, bhutchings@solarflare.com, andreas@fatal.se,
       hadi@cyberus.ca, hideaki@yoshifuji.org
Subject: Re: [PATCH v2] xtables: make XT_ALIGN() usable in exported headers
 by exporting __ALIGN_KERNEL()
Message-ID: <20100414125007.GB25686@x200>
References: <20100407162245.GA4557@x200>
 <4BC437C6.8020602@trash.net>
 <4BC44117.80901@trash.net>
 <20100414120712.GA25686@x200>
 <4BC450A4.1010200@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC450A4.1010200@trash.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 01:08:20PM +0200, Patrick McHardy wrote:
> Alexey Dobriyan wrote:
> > XT_ALIGN() was rewritten through ALIGN() by commit 42107f5009da223daa800d6da6904d77297ae829
> > "netfilter: xtables: symmetric COMPAT_XT_ALIGN definition".
> > ALIGN() is not exported in userspace headers, which created compile problem for tc(8)
> > and will create problem for iptables(8).
> > 
> > We can't export generic looking name ALIGN() but we can export less generic
> > __ALIGN_KERNEL() (suggested by Ben Hutchings).
> > Google knows nothing about __ALIGN_KERNEL().
> > 
> > COMPAT_XT_ALIGN() changed for symmetry.
> 
> I've already pushed your change out, could you send me an incremental
> fix please?
> 
> master.kernel.org:/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git

[PATCH] Restore __ALIGN_MASK()

Fix lib/bitmap.c compile failure due to __ALIGN_KERNEL changes.

---
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -40,6 +40,7 @@ extern const char linux_proc_banner[];
 #define STACK_MAGIC	0xdeadbeef
 
 #define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
+#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
 #define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 #define IS_ALIGNED(x, a)		(((x) & ((typeof(x))(a) - 1)) == 0)
 
