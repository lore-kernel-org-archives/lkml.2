Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1CMOYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 10:24:31 -0400
Received: from www.tglx.de ([62.245.132.106]:54539 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab1CMOYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 10:24:21 -0400
Date: Sun, 13 Mar 2011 15:23:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 2/8] x86: Use syscore_ops instead of sysdev classes and
 sysdevs
In-Reply-To: <201103122215.48206.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1103131500340.2787@localhost6.localdomain6>
References: <201103100131.58206.rjw@sisk.pl> <201103122212.40828.rjw@sisk.pl> <201103122215.48206.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Mar 2011, Rafael J. Wysocki wrote:
> -static int lapic_resume(struct sys_device *dev)
> +static void lapic_resume(void)
>  {
>  	unsigned int l, h;
>  	unsigned long flags;
> @@ -2083,7 +2083,7 @@ static int lapic_resume(struct sys_devic
>  	struct IO_APIC_route_entry **ioapic_entries = NULL;
>  
>  	if (!apic_pm_state.active)
> -		return 0;
> +		return;
>  
>  	local_irq_save(flags);

That want's the following on top:

@@ -2079,8 +2079,7 @@ static void lapic_resume(void)
 {
 	unsigned int l, h;
 	unsigned long flags;
-	int maxlvt;
-	int ret = 0;
+	int maxlvt, ret;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 
 	if (!apic_pm_state.active)
@@ -2091,7 +2090,6 @@ static void lapic_resume(void)
 		ioapic_entries = alloc_ioapic_entries();
 		if (!ioapic_entries) {
 			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			ret = -ENOMEM;
 			goto restore;
 		}

Otherwise, Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks,

	tglx
