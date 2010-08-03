Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0HCKYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:24:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41310 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0HCKYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lNhRAWKmZBf23NleDqlYx4+6V6UEuNxbQt/WbGbAuJD7B7eMtFDXVly43xm4/5UWvo
         e62iilR+vKg7cXlklCYnU7r06DausoP1fEWrrQRjZ3NBT/libm7kl9YahvDt63K1ofWa
         e9Pr9iqGhLD2vuHoQrblNbVCeUiPM82Vyypgo=
Message-ID: <4C57EE69.4080209@gmail.com>
Date: Tue, 03 Aug 2010 13:24:41 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: hacklu <embedway.linux@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how about KBUILD_MODNAME
References: <201008031037022524247@gmail.com> <201008031511572638256@gmail.com> <4C57E6F9.6080104@panasas.com> <4C57E7EB.4090904@gmail.com> <20100803101544.GJ5129@cr0.nay.redhat.com>
In-Reply-To: <20100803101544.GJ5129@cr0.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 01:15 PM, Américo Wang wrote:
> 
> And it doesn't make sense to hold two drivers in one .c file.
> 

I meant when two drivers share the same .c file. But instead of
using a third common module they just share it by duplicating
the code. example:

<Kbuild>
drv1-y := drv-one.o common.o
obj-$(CONFIG_DRV1) += drv1.o

drv2-y := drv-two.o common.o
obj-$(CONFIG_DRV2) += drv2.o
</Kbuild>

When compiling common.o the KBUILD_MODNAME fails to be set

Cheers
Boaz
