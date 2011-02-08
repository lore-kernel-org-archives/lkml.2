Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1BHN1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:27:14 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47562 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1BHN1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Oh2fhdb8/I4a9uQtkX+ZKRm6g4z7ic+FbcjHTiqAHZfMOvUks+tqrnH+f4utCcxaz9
         /ti6+36RVi1pWictibIok/6jdDcBqU6x5GZM/eZSoj4zCJfZVXmzIxAnaMAWWv49WjD5
         z6R8QXMJmwoDqxOdzfpTrUDN3XYs7T+sXFqh4=
MIME-Version: 1.0
In-Reply-To: <20110208131321.6ceb9a43@lxorguk.ukuu.org.uk>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122534.19110.89437.sendpatchset@linux-mhg7.site>
	<20110208131321.6ceb9a43@lxorguk.ukuu.org.uk>
Date: Tue, 8 Feb 2011 14:27:10 +0100
Message-ID: <AANLkTikYXWAbCjLpSyEqgDKBsZuM1na-tohLoLJx3Yr4@mail.gmail.com>
Subject: Re: [PATCH 16/20] ata_piix: add EFAR SLC90E66 support
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 2:13 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 08 Feb 2011 13:25:34 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
>
>> >From 11bed7feff5de752c9440ca58b232846b20e2ed6 Mon Sep 17 00:00:00 2001
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Tue, 8 Feb 2011 12:39:28 +0100
>> Subject: [PATCH 16/20] ata_piix: add EFAR SLC90E66 support
>>
>> Add EFAR SLC90E66 support to ata_piix and remove no longer
>> needed pata_efar driver.
>
> Jeff specifically asked that these were not all folded into ata_piix
> originally. This also makes memory usage higher and the system less
> efficient as these are all motherboard chipsets (except an obscure dual
> PIIX4 setup) so you are loading more not less code.

A lot more from a generic SCSI code if you want to optimize things for
old or embedded systems. IMHO this is not a best place to look for
such optimizations because maintenance cost > potential savings (i.e.
making SCSI quirks optional, I have draft patch for this, itself cuts
like 10k).

> It also leads to hideous uglies in the main code paths like this :
>
> +       unsigned int has_sitre  = (dev->vendor != 0x8086 ||
> +                                  dev->device != 0x1230);
>
> which also has exactly zero comments.

has_sitre variable name is documentation in itself for anyone knowing
the hardware or has read a chipset/code documentation.

Though more comments can certainly be added if needed..
