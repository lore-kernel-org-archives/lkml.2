Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967Ab0K3SSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:18:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755854Ab0K3SSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:18:50 -0500
Date: Tue, 30 Nov 2010 10:17:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v2 2/3] ACPI, APEI, Add APEI generic error status print
 support
Message-Id: <20101130101744.17efdea4.akpm@linux-foundation.org>
In-Reply-To: <987664A83D2D224EAE907B061CE93D530191E8BCF1@orsmsx505.amr.corp.intel.com>
References: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
	<1291085501-31494-3-git-send-email-ying.huang@intel.com>
	<20101129190343.7d7cea12.akpm@linux-foundation.org>
	<987664A83D2D224EAE907B061CE93D530191E8BCF1@orsmsx505.amr.corp.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 10:00:47 -0800 "Luck, Tony" <tony.luck@intel.com> wrote:

> > +	for (i = 0; i < strs_size; i++) {
> > +		if (!(bits & (1U << i)))
> > +			continue;
> > +		str = strs[i];
> > +		if (len && len + strlen(str) + 2 > 80) {
> > +			printk("\n");
> > +			len = 0;
> > +		}
> > +		if (!len)
> > +			len = pr_pfx(pfx, "%s", str);
> > +		else
> > +			len += printk(", %s", str);
> > +	}
> > +	if (len)
> > +		printk("\n");
> 
> Does printk() offer any guarantees about getting all the characters
> from a single printk() call out to the console without interleaving
> with messages from printk() calls on other cpus?

Yes, it uses logbuf_lock to atomically append all the output from a
printk into log_buf[].  Then it calls the console drivers against
log_buf[].  It's hard to see how a console driver could then screw that
up.

>  If it does, then
> it would be a good idea to sprintf() the parts of this message to
> a buffer and then use one printk() call.

yup.

>  I think I read that netconsole
> ends up with one packet on the wire for each call to printk().
> 
> Trying to parse output jumbled together from multiple cpus
> doesn't sound like fun.
> 
> -Tony
