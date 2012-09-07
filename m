Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab2IGIC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:02:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:53574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab2IGICY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:02:24 -0400
Subject: Re: [PATCH] x86, efi: 1:1 pagetable mapping for virtual EFI calls
From: Matt Fleming <matt.fleming@intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vasco Dias <rafa.vasco@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, cJ-ko@zougloub.eu
In-Reply-To: <5049C12B020000780009998C@nat28.tlf.novell.com>
References: <1346937309-1581-1-git-send-email-matt@console-pimps.org>
	 <5048D09A020000780009965B@nat28.tlf.novell.com>
	 <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
	 <5048D83D.8000408@zytor.com>
	 <5049C12B020000780009998C@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Fri, 07 Sep 2012 09:02:11 +0100
Message-ID: <1347004931.4244.112.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 08:40 +0100, Jan Beulich wrote:
> >>> On 06.09.12 at 19:07, "H. Peter Anvin" <hpa@zytor.com> wrote:
> > Anyone care to refresh my memory why we can't use the "global" 
> > 1:1+kernel map, possibly with some improvements (which would benefit the 
> > users of those maps too)?  With that I mean initial_page_map on i386 and 
> > trampoline_pgd on x86-64...
> 
> I don't think you want anything inserted in the low part of those
> (kernel-only) page tables, not even transiently.

There are already things inserted into the low part of those page
tables. In fact, the main purpose is to provide a 1:1 mapping for
realmode code. See machine_real_restart().

I think there's definitely merit to the approach Peter outlined above.
There's a variety of places in arch/x86 where a 1:1 mapping is needed.
It would be good to have a single pagetable that provides this.

