Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2CEVqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:46:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab2CEVq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:46:29 -0500
Date: Mon, 5 Mar 2012 16:45:45 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        paulus@samba.org, mingo@elte.hu, acme@ghostprotocols.net,
        Vegard Nossum <vegardno@ifi.uio.no>, tony.luck@intel.com, bp@amd64.org,
        robert.richter@amd.com, lenb@kernel.org, minyard@acm.org,
        wim@iguana.be, linux-edac@vger.kernel.org, oprofile-list@lists.sf.net,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 x86 1/2]  fix page faults by nmiaction in nmi if
 kmemcheck is enabled
Message-ID: <20120305214545.GH3083@redhat.com>
References: <1329717665.3448.28.camel@ThinkPad-T61>
 <1329735648.2293.307.camel@twins>
 <1329788560.3448.45.camel@ThinkPad-T61>
 <1329819437.2293.382.camel@twins>
 <1329990828.19165.36.camel@ThinkPad-T61>
 <1330340324.11248.60.camel@twins>
 <1330941917.24353.63.camel@ThinkPad-T61>
 <1330969747.11248.250.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330969747.11248.250.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 06:49:07PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-05 at 18:05 +0800, Li Zhong wrote:
> > +static struct nmiaction arch_trigger_all_cpu_bt_nmiaction = {
> > +       .handler        = arch_trigger_all_cpu_backtrace_handler,
> > +       .name           = "arch_bt",
> > +};
> > +
> >  static int __init register_trigger_all_cpu_backtrace(void)
> >  {
> > -       register_nmi_handler(NMI_LOCAL, arch_trigger_all_cpu_backtrace_handler,
> > -                               0, "arch_bt");
> > +       register_nmi_handler(NMI_LOCAL, &arch_trigger_all_cpu_bt_nmiaction);
> >         return 0;
> >  } 
> 
> If you look at things like cpu_notifier() you can shorten this still:
> 
> #define nmi_notifier(t, fn, n)				\
> do {							\
> 	static struct nmiaction fn##_na = {		\
> 		.handler = (fn),			\
> 		.name = (n),				\
> 	};						\
> 	register_nmi_handler((t), &fn##_na);		\
> } while (0)
> 
> The whole thing then becomes:
> 
>   nmi_notifier(NMI_LOCAL, arch_trigger_all_cpu_backtrace_handler, "arch_bt");

Hi Li,

I would be open to this suggestion.  If you want to modify the patch for
this approach.

Cheers,
Don
