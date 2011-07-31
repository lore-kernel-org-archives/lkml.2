Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1GaCJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 22:09:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48776 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1GaCJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 22:09:01 -0400
MIME-Version: 1.0
In-Reply-To: <4E34AFAD.90008@zytor.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<1312067670.22074.61.camel@i7.infradead.org>
	<CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	<4E34998D.8060806@zytor.com>
	<CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	<4E34A1E4.8040103@zytor.com>
	<CACqU3MVkLXoBq7KP2Jff=p7EiKR7DkPa4z7y0Rdah-dGzRvj4g@mail.gmail.com>
	<4E34AFAD.90008@zytor.com>
Date: Sat, 30 Jul 2011 22:09:00 -0400
Message-ID: <CACqU3MUJ=B-VszESWcFXbW=TLRxz5HrAaUn3nkyydX-xBBTXhg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 30, 2011 at 9:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/30/2011 06:06 PM, Arnaud Lacombe wrote:
>>>
>> The principle of least surprise is broken anyway as the proposed patch
>> has absolutely no dependency checking and verification. You can `make
>> CONFIG_SATA_MV=y allnoconfig', you will _not_ get it set.
>>
> This gives you exactly the same way as a .config file or a ALLCONFIG
> file with the same options, which is what one realistically should expect.
>
no, I would expect it to have the same effect as a `select
CONFIG_SATA_MV', have it forcibly set to the given value, and be
warned if there was any problem.

Btw, `make CONFIG_GENERIC_BUG=n oldconfig' or `make CONFIG_64BIT=n
oldconfig'[0] does not even work, and I'm getting no error. So either
you make it work for all possible uses, or you warn the user he tried
something illegal, but you don't just fail silently.

>From my point of view, this patch, as-is, open a delicate Pandora's box.

 - Arnaud

[0]: which is still funny to do with CONFIG_X86_64=y :)
