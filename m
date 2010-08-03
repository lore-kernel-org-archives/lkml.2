Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab0HCVpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:45:40 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45210 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab0HCVpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:45:39 -0400
To: Huang Ying <ying.huang@intel.com>
Cc: "Tang\, Feng" <feng.tang@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: EFI runtime-services on x86_64
References: <201007301458.50263.bjorn.helgaas@hp.com>
	<20100802103535.6442ab49@feng-i7>
	<1280716920.2771.1519.camel@yhuang-dev>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 14:45:33 -0700
In-Reply-To: <1280716920.2771.1519.camel@yhuang-dev> (Huang Ying's message of "Mon\, 02 Aug 2010 10\:42\:00 +0800")
Message-ID: <m14ofbgyki.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> writes:

> Hi, Bjorn,
>
> On Mon, 2010-08-02 at 10:35 +0800, Tang, Feng wrote:
>> Hi Bjorn,
>> 
>> On Sat, 31 Jul 2010 04:58:48 +0800
>> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>> 
>> > Hello Feng,
>> > 
>> > Can you educate me about your commit 772be899bc, "86: Make EFI RTC
>> > function depend on 32bit again"?
>> > 
>> > It adds "#ifdef CONFIG_X86_32" to avoid using efi_get_time() and
>> > efi_set_rtc_mmss(), but there's no explanation of *why* those services
>> > only work on 32-bit.
>> > 
>> > Is this an EFI spec limitation?  Do the other EFI runtime services
>> > work on 64-bit, since you didn't touch them?  Or do we just not use
>> > any of the others?
>> > 
>> 
>> Commit 772be899bc, "86: Make EFI RTC function depend on 32bit again" is
>> a regression fix for 7bd867d "x86: Move get/set_wallclock to x86_platform_ops".
>> These 2 commits just abstract the rtc service for legacy x86 PC/EFI/Virtualiation
>> kernel, and has no functional change to existing code.
>> 
>> I'm not familiar with EFI, but my understanding is current EFI code in 
>> kernel only provides the get/set_time service for x86_32 platform.
>
> I think get/set_time service should have worked on x86_64 too. Just
> lacks proper debugging/testing for recent kernels.

Is there any reason we just don't rip those calls out?

If we don't need them and we lack proper debug/testing I don't see the point
of using the EFI calls and exposing ourselves to more potential BIOS breakage.

EFI runtime calls have the nasty fact that they don't work in general even
if EFI is present because you may have the wrong word size EFI running on
your machine.  A 32bit EFI and a 64bit kernel or a 64bit EFI and a 32bit kernel.

Eric
