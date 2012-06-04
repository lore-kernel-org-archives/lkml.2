Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2FDIL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:11:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44797 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2FDILY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 4 Jun 2012 04:11:24 -0400
Message-Id: <4FCC89C60200007800088112@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 04 Jun 2012 09:11:18 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt.fleming@intel.com>, <mjg@redhat.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
References: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
 <1338028008.16679.1.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1338028008.16679.1.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.05.12 at 12:26, Matt Fleming <matt.fleming@intel.com> wrote:
> On Fri, 2012-05-25 at 16:20 +0100, Jan Beulich wrote:
>> Other than ix86, x86-64 on EFI so far didn't set the {g,s}et_wallclock
>> accessors to the EFI routines, thus incorrectly using raw RTC accesses
>> instead.
>> 
>> Simply removing the #ifdef around the respective code isn't enough,
>> however: While so far early get-time calls were done in physical mode,
>> this doesn't work properly for x86-64, as virtual addresses would still
>> need to be set up for all runtime regions (which wasn't the case on the
>> system I have access to), so instead the patch moves the call to
>> efi_enter_virtual_mode() ahead (which in turn allows to drop all code
>> related to calling efi-get-time in physical mode).
>> 
>> Additionally the earlier calling of efi_set_executable() requires the
>> CPA code to cope, i.e. during early boot it must be avoided to call
>> cpa_flush_array(), as the first thing this function does is a
>> BUG_ON(irqs_disabled()).
>> 
>> Also make the two EFI functions in question here static - they're not
>> being referenced elsewhere.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> Cc: Matt Fleming <matt.fleming@intel.com>
>> Cc: Matthew Garrett <mjg@redhat.com>
>> 
>> ---
>> (Note that due to the lack of hardware I wasn't able to test this on
>> 32-bit EFI - Matt offered to do so subsequently.)
> 
> Appears to work fine here on 32-bit.

Is there any further action required on my part here? Is it clear
through who's hands this would need to go in order to make it in
for 3.6 at least?

Thanks, Jan

