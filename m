Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935Ab2FBScH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 14:32:07 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:43687 "EHLO
	homiemail-a56.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964796Ab2FBScF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 14:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=references
	:in-reply-to:mime-version:content-transfer-encoding:content-type
	:message-id:cc:from:subject:date:to; q=dns; s=shealevy.com; b=ES
	7JYoTFfHjYn8KG12zs2aBlmMTygkZWFbn68HRuafLS2sn0IIb0h+PT6PoyJJY8MJ
	WHKEvr0wNd33NtmpY7U8Phxj2y7ONd4NzK67ABcNfD8W5dCVzd7g+xGlnHAaG7dZ
	w0DiURjhF4Eo0LUatcbIyyQPwyDN1Wmuo343LF968=
References: <4F660313.1080301@shealevy.com> <4F660402.4040300@shealevy.com> <4F690314.3080601@shealevy.com> <1338478869.13028.64.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1338478869.13028.64.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <3609623F-DE19-47CA-B59C-C6C8B292CF35@shealevy.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, ThomasGleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
X-Mailer: iPad Mail (9B206)
From: Shea Levy <shea@shealevy.com>
Subject: Re: [RFC][PATCH 1/1] x86, efi: EFI boot stub config file support
Date: Sat, 2 Jun 2012 14:32:01 -0400
To: Matt Fleming <matt.fleming@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 31, 2012, at 11:41, Matt Fleming <matt.fleming@intel.com> wrote:

> On Tue, 2012-03-20 at 18:22 -0400, Shea Levy wrote:
>> On 03/18/2012 11:49 AM, Shea Levy wrote:
>>> On 3/18/12 11:45 AM, Shea Levy wrote:
>>>> Hello,
>>>> 
>>>> Inlined is a patch to have the kernel read its parameters from a
>>>> config file when booted via the EFI boot stub without any parameters
>>>> passed. This patch roughly follows the plan I discussed when
>>>> proposing this idea, except now the file is found relative to the
>>>> location of the bzImage and there is no additional check to see if
>>>> image->parent_handle is NULL (despite the spec saying it will be NULL
>>>> when the image was loaded by the firmware itself, it was never NULL
>>>> on any of the systems I tested).
>>>> 
>>>> Cheers,
>>>> Shea Levy
>> 
>> I haven't yet gotten a reply to this, should I wait until after the 
>> merge window and resubmit it then?
> 
> I'm wondering what use case you're catering for here that can't be
> handled with efibootmgr? What problem does this patch fix?
> 

This fixes cases where efibootmgr doesn't work, either by design (in the case of removable boot media like a livecd) or due to firmware non-conformity (like VirtualBox's EFI emulation).

I had been waiting for the efi_printk stuff to get merged (for some reason I was under the impression it would be in 3.4) before submitting an updated version of this, and in the mean-time have been using the EDK shell + a startup.nsh file for the livecd case.