Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2F1RCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:02:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54984 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2F1RCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:02:12 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <4FEB80A5.8020806@zytor.com>
References: <CAJ0yFaxO-ZU7d_RNbQ3y1cfB5EJL9wgvmgZk-nmkVOLoBRH88A@mail.gmail.com>
	<1340832957-7386-1-git-send-email-olof@lixom.net>
	<4FEB80A5.8020806@zytor.com>
Date: Thu, 28 Jun 2012 10:02:12 -0700
Message-ID: <CAOesGMhzAmpX0sSFv4w+=Y4Uzh77aa3_QW3JW=eurfo22dRMoA@mail.gmail.com>
Subject: Re: [PATCH] efi: add efi_runtime state checking
From: Olof Johansson <olof@lixom.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Marko Kohtala <marko.kohtala@gmail.com>, linux-kernel@vger.kernel.org,
        mjg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 2:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/27/2012 02:35 PM, Olof Johansson wrote:
>>
>> This adds an efi_runtime variable indicating whether the
>> efi runtime services are available. The only time they are
>> expected to not be available is when a 32-bit kernel has been
>> booted using 64-but EFI and vice versa.
>>
>> It also adds checking to the two locations where functions are
>> called; x86 reboot and efivars.
>>
>
> OK, stupid question:
>
> Why is this different from the efi_enabled variable, or rather: why is it
> different from what the efi_enabled variable *should* be?  If runtime
> services aren't available the only "EFI" that is available to the kernel are
> the data structures passed in, and those can be checked directly...

Excellent question, and I think it would work to turn off efi_enabled
towards the end of setup_arch() for non-native boots. That'd solve all
these problems, I believe.

I'll try it out and revise this patch. It might take me a day or two
to get cycles for it.


-Olof
