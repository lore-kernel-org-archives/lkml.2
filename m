Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab1KIF0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 00:26:09 -0500
Received: from ams-iport-3.cisco.com ([144.254.224.146]:43300 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1KIF0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 00:26:07 -0500
X-IronPort-AV: E=Sophos;i="4.69,481,1315180800"; 
   d="scan'208";a="2686989"
Date: Wed, 9 Nov 2011 10:56:07 +0530
From: Maneesh Soni <manesoni@cisco.com>
To: David Daney <david.daney@cavium.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "kamensky@cisco.com" <kamensky@cisco.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH 1/4] MIPS Kprobes: Fix OOPS in arch_prepare_kprobe()
Message-ID: <20111109052607.GA20317@cisco.com>
Reply-To: manesoni@cisco.com
References: <20111108170336.GA16526@cisco.com>
 <20111108170454.GB16526@cisco.com>
 <4EB989B9.2060904@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB989B9.2060904@cavium.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 11:57:45AM -0800, David Daney wrote:
> On 11/08/2011 09:04 AM, Maneesh Soni wrote:
> [...]
> >
> >diff --git a/arch/mips/kernel/kprobes.c b/arch/mips/kernel/kprobes.c
> >index ee28683..9fb1876 100644
> >--- a/arch/mips/kernel/kprobes.c
> >+++ b/arch/mips/kernel/kprobes.c
> >@@ -25,6 +25,7 @@
> >
> >  #include<linux/kprobes.h>
> >  #include<linux/preempt.h>
> >+#include<linux/uaccess.h>
> >  #include<linux/kdebug.h>
> >  #include<linux/slab.h>
> >
> >@@ -118,11 +119,19 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
> >  	union mips_instruction prev_insn;
> >  	int ret = 0;
> >
> >-	prev_insn = p->addr[-1];
> >  	insn = p->addr[0];
> >
> >-	if (insn_has_delayslot(insn) || insn_has_delayslot(prev_insn)) {
> >-		pr_notice("Kprobes for branch and jump instructions are not supported\n");
> >+	if (insn_has_delayslot(insn)) {
> >+		pr_notice("Kprobes for branch and jump instructions are not"
> >+			  "supported\n");
> 
> Don't wrap these strings.
> 
> It is better to go a little bit over 80 columns, than have this.
> 
> David Daney

Ok.. will keep that in mind for future patches. This line actually
goes away in patch 4/4.

Thanks
Maneesh
