Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1KGUXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:23:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab1KGUXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:23:39 -0500
Date: Mon, 7 Nov 2011 12:17:14 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Jones <davej@redhat.com>, Borislav Petkov <bp@amd64.org>,
        x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: BAD APICID ?
Message-ID: <20111107201714.GA14185@suse.de>
References: <20111107173948.GA1344@redhat.com>
 <20111107175402.GA3384@gere.osrc.amd.com>
 <20111107180950.GA6411@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107180950.GA6411@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 01:09:50PM -0500, Dave Jones wrote:
> On Mon, Nov 07, 2011 at 06:54:02PM +0100, Borislav Petkov wrote:
>  > On Mon, Nov 07, 2011 at 12:39:48PM -0500, Dave Jones wrote:
>  > > We got a report from a Fedora user hitting a WARN_ON in the apic setup code.
>  > > 
>  > > Here..
>  > > 
>  > > 1230 #ifdef CONFIG_X86_32
>  > > 1231         /*
>  > > 1232          * APIC LDR is initialized.  If logical_apicid mapping was
>  > > 1233          * initialized during get_smp_config(), make sure it matches the
>  > > 1234          * actual value.
>  > > 1235          */
>  > > 1236         i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
>  > > 1237         WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
>  > > 1238         /* always use the value from LDR */
>  > > 1239         early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
>  > > 1240                 logical_smp_processor_id();
>  > > 
>  > > The full report is at https://bugzilla.redhat.com/show_bug.cgi?id=743930
>  > > 
>  > > Report is against our 3.0 builds, but that code look unchanged in 3.1 too,
>  > > and even in current Linus head.
>  > > 
>  > > Any thoughts on what could cause this ?
>  > 
>  > Already fixed upstream: 838312be46f3abfbdc175f81c3e54a857994476d
>  > 
>  > Here's the whole thread: http://lkml.org/lkml/2011/10/14/231
>  > 
>  > HTH.
> 
> ah, excellent, thanks.
> That seems to have not hit stable, even though it was cc'd. Greg ?

It's already been queued up for the next stable release, which should be
coming out later this week once the firehose of the 3.2 merge window
slows down.

thanks,

greg k-h
