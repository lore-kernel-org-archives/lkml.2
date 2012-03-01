Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab2CAAVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:21:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38713 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab2CAAVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:21:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.236.77.102 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
In-Reply-To: <4F4EBF44.60208@zytor.com>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
	<4F4BF11E.4090000@zytor.com>
	<CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
	<4F4C1F76.70403@zytor.com>
	<alpine.DEB.2.00.1202281927130.24649@be10.lrz>
	<4F4D1E6A.5000200@zytor.com>
	<CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
	<4F4E6B98.2090306@zytor.com>
	<CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com>
	<4F4EB0B9.2080906@zytor.com>
	<CAKL7Q7pq5BTax4odM5YuzR4TsoU5CV59341LziR9c=Yjnia4gQ@mail.gmail.com>
	<4F4EBF44.60208@zytor.com>
Date: Thu, 1 Mar 2012 01:21:04 +0100
Message-ID: <CAKL7Q7qBOe70D80wOqLnnPLQaaVWbb2KB5P5p252oyPS4YgD1Q@mail.gmail.com>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/1 H. Peter Anvin <hpa@zytor.com>:
> On 02/29/2012 03:51 PM, Joshua C. wrote:
>>
>> Will this work?
>>
>> +#if (defined(__i386__) || defined(__x86_64__))
>> +#include <asm/io.h>
>> +#include <asm/setup.h>
>> +#else
>> +extern struct boot_params boot_params;
>> +#endif
>>
>
> A much better way to do this is probably something like
>
> #ifdef CONFIG_X86
>
> #include <asm/setup.h>
>
> static inline int kbd_defleds(void)
> {
>        return boot_param.kbd_status & 0x20 ? (1 << VC_NUMLOCK) : 0;
> }
>
> #elif defined(CONFIG_PARISC)
> static inline int kbd_defleds(void)
> {
> # if defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD)
>        return 1 << VC_NUMLOCK;
> # else
>        return 0;
> # endif
> }
>
> #else
>
> static inline int kbd_defleds(void)
> {
>        return 0;
> }
>
> #endif
>
> ... then arguably this should be moved into the arch/* directories, in a
> header file or by making this a callable function.
>
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>

Thanks for the help. You can better figure out where this code should
go into. Can you prepare the patch for merging in the mainline kernel?
