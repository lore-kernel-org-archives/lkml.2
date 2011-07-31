Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab1GaFVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:21:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42532 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1GaFV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:21:27 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUJ=B-VszESWcFXbW=TLRxz5HrAaUn3nkyydX-xBBTXhg@mail.gmail.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<1312067670.22074.61.camel@i7.infradead.org>
	<CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	<4E34998D.8060806@zytor.com>
	<CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	<4E34A1E4.8040103@zytor.com>
	<CACqU3MVkLXoBq7KP2Jff=p7EiKR7DkPa4z7y0Rdah-dGzRvj4g@mail.gmail.com>
	<4E34AFAD.90008@zytor.com>
	<CACqU3MUJ=B-VszESWcFXbW=TLRxz5HrAaUn3nkyydX-xBBTXhg@mail.gmail.com>
Date: Sun, 31 Jul 2011 01:21:27 -0400
Message-ID: <CACqU3MXjBsJ=nWL8ue6JGGVQTej8f3CcUvFtS3n6K+henHzvuQ@mail.gmail.com>
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

On Sat, Jul 30, 2011 at 10:09 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Sat, Jul 30, 2011 at 9:28 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/30/2011 06:06 PM, Arnaud Lacombe wrote:
>>>>
>>> The principle of least surprise is broken anyway as the proposed patch
>>> has absolutely no dependency checking and verification. You can `make
>>> CONFIG_SATA_MV=y allnoconfig', you will _not_ get it set.
>>>
>> This gives you exactly the same way as a .config file or a ALLCONFIG
>> file with the same options, which is what one realistically should expect.
>>
> no, I would expect it to have the same effect as a `select
> CONFIG_SATA_MV', have it forcibly set to the given value, and be
> warned if there was any problem.
>
> Btw, `make CONFIG_GENERIC_BUG=n oldconfig' or `make CONFIG_64BIT=n
> oldconfig'[0] does not even work, and I'm getting no error. So either
> you make it work for all possible uses, or you warn the user he tried
> something illegal, but you don't just fail silently.
>
ok, the issue is that you will only be allowed to change visible
symbols. CONFIG_64BIT is conditionally visible (when ARCH=x86), so
right now, you can not do on x86-64:

% make ARCH=i386 defconfig
% make CONFIG_64BIT=n oldconfig # [0]

and expect it to work.

Instead of allowing explicitly a symbol to be overridden, the behavior
is to implicitly, silently and un-deterministicaly[1] deny an
override. Strange ...

 - Arnaud

[0]: this match David's use-case described in
<1311986969.20983.52.camel@i7.infradead.org>

[1]: ie. it depends on the state of the tree when ran
