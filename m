Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab1HPSIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 14:08:39 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56276 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1HPSIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 14:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110816175750.GA25099@suse.de>
References: <1313515355-28920-1-git-send-email-fabio.estevam@freescale.com>
	<CACqU3MU2f17tb_5jjtT6TG0jw4P5JzR7=774QOoJ_T01wSmXHQ@mail.gmail.com>
	<20110816175750.GA25099@suse.de>
Date: Tue, 16 Aug 2011 14:08:37 -0400
Message-ID: <CACqU3MWFiCFG+MeosgUL2eOboEj5-XdVH0M9WgfYJ0vOc-CJdQ@mail.gmail.com>
Subject: Re: [PATCH] devtmpfs: Annotate devtmpfsd as __init
From: Arnaud Lacombe <lacombar@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 16, 2011 at 1:57 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Aug 16, 2011 at 01:30:06PM -0400, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Tue, Aug 16, 2011 at 1:22 PM, Fabio Estevam
>> <fabio.estevam@freescale.com> wrote:
>> > This fixes the following:
>> >
>> > WARNING: vmlinux.o(.text+0x1ed41c): Section mismatch in reference from the function devtmpfsd() to the (unknown reference) .init.data:(unknown)
>> > The function devtmpfsd() references
>> > the (unknown reference) __initdata (unknown).
>> > This is often because devtmpfsd lacks a __initdata
>> > annotation or the annotation of (unknown) is wrong.
>> >
>> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>> >
>> I already submitted a patch for that https://patchwork.kernel.org/patch/996132/
>
> And it's in linux-next, right?
>
Yes.

commit f9e0b159dbff693bacb64a929e04f442df985b50
Author: Arnaud Lacombe <lacombar@gmail.com>
Date:   Thu Jul 21 13:16:19 2011 -0400

    drivers/base/devtmpfs.c: correct annotation of `setup_done'

    This fixes the following section mismatch issue:

    WARNING: vmlinux.o(.text+0x1192bf): Section mismatch in reference
from the function devtmpfsd() to the variable .init.data:setup_done
    The function devtmpfsd() references the variable __initdata setup_done.
    This is often because devtmpfsd lacks a __initdata annotation or
the annotation of setup_done is wrong.

    WARNING: vmlinux.o(.text+0x119342): Section mismatch in reference
from the function devtmpfsd() to the variable .init.data:setup_done
    The function devtmpfsd() references the variable __initdata setup_done.
    This is often because devtmpfsd lacks a __initdata annotation or
the annotation of setup_done is wrong.

    Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

 - Arnaud

> thanks,
>
> greg k-h
>
