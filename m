Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab2IGHTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:19:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47301 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2IGHTI convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Fri, 7 Sep 2012 03:19:08 -0400
Message-Id: <5049BC410200007800099944@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 07 Sep 2012 08:20:01 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt.fleming@intel.com>
Cc: "Vasco Dias" <rafa.vasco@gmail.com>, "Matthew Garrett" <mjg@redhat.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cJ-ko@zougloub.eu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, efi: 1:1 pagetable mapping for virtual EFI
 calls
References: <1346937309-1581-1-git-send-email-matt@console-pimps.org>
 <5048D09A020000780009965B@nat28.tlf.novell.com>
 <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.09.12 at 17:47, Matt Fleming <matt.fleming@intel.com> wrote:
> On Thu, 2012-09-06 at 15:34 +0100, Jan Beulich wrote:
>> >>> On 06.09.12 at 15:15, Matt Fleming <matt@console-pimps.org> wrote:
>> > +	__flush_tlb_all();
>> 
>> Is it certain you will _never_ hit a global mapping (in which case I
>> believe the above would be insufficient)?
> 
> Are you saying that this should be a flush_tlb_all() if we have global
> mappings? Or that if we are guaranteed to never have global mappings we
> can opitmise this by simply doing a __flush_tlb()?

Hmm, looks like I shouldn't have worked from memory -
other than I remembered, __flush_tlb_all() does take care
of global pages. But indeed, if we can be sure that no global
mappings would ever exist in the replaced (low) part of the
address space, then __flush_tlb() would be sufficient. But I
would agree that for a first round (and possibly forever,
particularly as long as performance doesn't matter) it's safer
to use the more aggressive flush. So please disregard my
respective comment to that part of your patch.

Jan

