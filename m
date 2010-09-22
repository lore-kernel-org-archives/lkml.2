Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0IVVXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:23:01 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29778 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0IVVXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:23:00 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: tidy e820 output
Date: Wed, 22 Sep 2010 15:22:06 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221311.19567.bjorn.helgaas@hp.com> <4C9A6FF4.2060201@kernel.org>
In-Reply-To: <4C9A6FF4.2060201@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221522.06873.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010 03:07:00 pm Yinghai Lu wrote:
> On 09/22/2010 12:11 PM, Bjorn Helgaas wrote:

> > -static void __init e820_print_type(u32 type)
> > +static char * __init e820_type_name(u32 type)
> >  {
> >  	switch (type) {
> >  	case E820_RAM:
> >  	case E820_RESERVED_KERN:
> > -		printk(KERN_CONT "(usable)");
> > -		break;
> > +		return "usable";
> >  	case E820_RESERVED:
> > -		printk(KERN_CONT "(reserved)");
> > -		break;
> > +		return "reserved";
> >  	case E820_ACPI:
> > -		printk(KERN_CONT "(ACPI data)");
> > -		break;
> > +		return "ACPI data";
> >  	case E820_NVS:
> > -		printk(KERN_CONT "(ACPI NVS)");
> > -		break;
> > +		return "ACPI NVS";
> >  	case E820_UNUSABLE:
> > -		printk(KERN_CONT "(unusable)");
> > -		break;
> > -	default:
> > -		printk(KERN_CONT "type %u", type);
> > -		break;
> > +		return "unusable";
> >  	}
> > +	return "(unknown)";
> >  }
> 
> type value?

I decided the code simplification was worth skipping the type.
I'd certainly rather have the type value, too, but I don't know
how much hassle to go through to debug a firmware problem.  How
important do you think it is?

Bjorn
