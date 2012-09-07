Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab2IGIGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:06:47 -0400
Received: from mga10.intel.com ([192.55.52.92]:26162 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756080Ab2IGIGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:06:40 -0400
Subject: Re: [PATCH] x86, efi: 1:1 pagetable mapping for virtual EFI calls
From: Matt Fleming <matt.fleming@intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Vasco Dias <rafa.vasco@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cJ-ko@zougloub.eu, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <5049C1DB020000780009998F@nat28.tlf.novell.com>
References: <1346937309-1581-1-git-send-email-matt@console-pimps.org>
	 <5048D09A020000780009965B@nat28.tlf.novell.com>
	 <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5049C1DB020000780009998F@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Fri, 07 Sep 2012 09:06:28 +0100
Message-ID: <1347005188.4244.116.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 08:43 +0100, Jan Beulich wrote:
> >>> On 06.09.12 at 17:47, Matt Fleming <matt.fleming@intel.com> wrote:
> > On Thu, 2012-09-06 at 15:34 +0100, Jan Beulich wrote:
> >> >>> On 06.09.12 at 15:15, Matt Fleming <matt@console-pimps.org> wrote:
> >> > +
> >> > +		pgd += i;
> >> > +		save[i] = *pgd;
> >> > +		set_pgd(pgd, efi_one_to_one_pgd[i]);
> >> > +	}
> >> 
> >> Did you, as an alternative, consider switching to a different
> >> CR3 instead of copying back and forth?
> > 
> > I did consider it, but I couldn't convince myself whether or not the EFI
> > pagetable would need to be manually kept in sync with any other
> > pagetables. But now I look at the code a bit harder, it seems that
> > should be taken care of automatically. In fact, the tboot code seems to
> > do something similar. I'll try that approach.
> 
> Actually, I think the copying approach is even broken - what if
> multiple threads currently on the same address space want to
> invoke a runtime call simultaneously? The first one to get here
> would save the right values, but the second one wouldn't.

Yeah, unfortunately I only realised that after I'd sent the patch.
Switching pagetables around efi calls is a much better approach.

