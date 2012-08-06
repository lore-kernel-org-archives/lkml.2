Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab2HFGol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 02:44:41 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38793 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab2HFGoj (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:2>);
	Mon, 6 Aug 2012 02:44:39 -0400
Message-Id: <501F83F20200007800092C1C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 06 Aug 2012 07:44:34 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <cJ-ko@zougloub.eu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ingo Molnar" <mingo@kernel.org>,
        "Matt Fleming" <matt.fleming@linux.intel.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform
 wall clock" prevents my machine from booting
References: <20120805172903.5f8bb24c@zougloub.eu>
 <501EF3A2.20200@zytor.com>
In-Reply-To: <501EF3A2.20200@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.08.12 at 00:28, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 08/05/2012 02:29 PM, Jérôme Carretero wrote:
>> Hi,
>>
>> My PC (AMD Bulldozer + Asus SABERTOOTH 990FX) booted fine from UEFI
>> and it broke between v3.5 and v3.6-rc1.
>> Other machines with old BIOSes booted fine so I looked into EFI-related
>> patches trying to revert them, because I didn't know what else to do.
>>
>> Bingo, bacef661: x86-64/efi: Use EFI to deal with platform wall clock.
>>
>> At the moment I reverted this commit after v3.6-rc1-133-g42a579a,
>> and it boots fine.
>>
>> This really not my domain so tell me if I can help testing.
>>
> 
> Thank you... we were aware of the problem but had not been able to 
> reproduce it, so we had hoped someone would bisect or otherwise identify 
> the faulty patch.

Faulty? Without technical detail I'd be careful with this, as there's
too many broken EFI implementation around.

The only change that has a (very low) potential for causing
problems by itself is the earlier calling of efi_enter_virtual_mode(),
which was requested/recommended by Matthew.

I am e.g. (meanwhile) aware of (Intel) systems that use floating
point instructions in the UEFI runtime code, which is clearly a
violation of the spec; having the kernel continue to be not spec
compliant is a questionable tradeoff.

In any case, without having seen _how_ things break I don't
think a decision should be taken if/how to address this
(apparent) regression.

Jan
