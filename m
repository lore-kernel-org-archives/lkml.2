Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab2EZK1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 06:27:10 -0400
Received: from mga06.intel.com ([134.134.136.21]:2906 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752422Ab2EZK1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 06:27:08 -0400
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
From: Matt Fleming <matt.fleming@intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
References: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Sat, 26 May 2012 11:26:48 +0100
Message-ID: <1338028008.16679.1.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 16:20 +0100, Jan Beulich wrote:
> Other than ix86, x86-64 on EFI so far didn't set the {g,s}et_wallclock
> accessors to the EFI routines, thus incorrectly using raw RTC accesses
> instead.
> 
> Simply removing the #ifdef around the respective code isn't enough,
> however: While so far early get-time calls were done in physical mode,
> this doesn't work properly for x86-64, as virtual addresses would still
> need to be set up for all runtime regions (which wasn't the case on the
> system I have access to), so instead the patch moves the call to
> efi_enter_virtual_mode() ahead (which in turn allows to drop all code
> related to calling efi-get-time in physical mode).
> 
> Additionally the earlier calling of efi_set_executable() requires the
> CPA code to cope, i.e. during early boot it must be avoided to call
> cpa_flush_array(), as the first thing this function does is a
> BUG_ON(irqs_disabled()).
> 
> Also make the two EFI functions in question here static - they're not
> being referenced elsewhere.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> 
> ---
> (Note that due to the lack of hardware I wasn't able to test this on
> 32-bit EFI - Matt offered to do so subsequently.)

Appears to work fine here on 32-bit.

