Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1CMPHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:07:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54781 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1CMPHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:07:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/8] x86: Use syscore_ops instead of sysdev classes and sysdevs
Date: Sun, 13 Mar 2011 16:07:59 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc8+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Dave Jones <davej@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Avi Kivity <avi@redhat.com>
References: <201103100131.58206.rjw@sisk.pl> <201103122215.48206.rjw@sisk.pl> <alpine.LFD.2.00.1103131500340.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103131500340.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103131607.59855.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 13, 2011, Thomas Gleixner wrote:
> On Sat, 12 Mar 2011, Rafael J. Wysocki wrote:
> > -static int lapic_resume(struct sys_device *dev)
> > +static void lapic_resume(void)
> >  {
> >  	unsigned int l, h;
> >  	unsigned long flags;
> > @@ -2083,7 +2083,7 @@ static int lapic_resume(struct sys_devic
> >  	struct IO_APIC_route_entry **ioapic_entries = NULL;
> >  
> >  	if (!apic_pm_state.active)
> > -		return 0;
> > +		return;
> >  
> >  	local_irq_save(flags);
> 
> That want's the following on top:
> 
> @@ -2079,8 +2079,7 @@ static void lapic_resume(void)
>  {
>  	unsigned int l, h;
>  	unsigned long flags;
> -	int maxlvt;
> -	int ret = 0;
> +	int maxlvt, ret;
>  	struct IO_APIC_route_entry **ioapic_entries = NULL;
>  
>  	if (!apic_pm_state.active)
> @@ -2091,7 +2090,6 @@ static void lapic_resume(void)
>  		ioapic_entries = alloc_ioapic_entries();
>  		if (!ioapic_entries) {
>  			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
> -			ret = -ENOMEM;
>  			goto restore;
>  		}

Right, I'll fold it into the final version of the patch.

> Otherwise, Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks!

Rafael
