Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1BWIgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:36:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab1BWIgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:36:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org, monstr@monstr.eu
Subject: Re: [PATCH v3 2/2] i2c: xiic: Use 32bit accesses only
Date: Wed, 23 Feb 2011 09:36:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-i2c@vger.kernel.org,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org
References: <1298396971-611-1-git-send-email-monstr@monstr.eu> <AANLkTinRVKMdOU-8DYLHe5q92nb3ysKnnG-jq8f++AEs@mail.gmail.com> <4D64C08F.5030604@monstr.eu>
In-Reply-To: <4D64C08F.5030604@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102230936.09921.arnd@arndb.de>
X-Provags-ID: V02:K0:cHCXoWaBULgYtLEuSt7jhVb775SnHkNp8Rta+X0vqVk
 2zWdhqw9GzdCku0yjEuXukV8E49xxaTBu7YhXDQVtAHofMvDyh
 WFrAizBSw0YWsiuoOa4ITtKTJKFxCvdE/b0C4tcyzp3zvImxlh
 NRmrWo6WGthcYqR7LqIqTDH5ggxLoo05JLoeVZM8DUh8ra4hy/
 nvdO8BS9YT3EweC5su54g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 February 2011 09:08:47 Michal Simek wrote:
> 
> Grant Likely wrote:
> > On Tue, Feb 22, 2011 at 10:49 AM, Michal Simek <monstr@monstr.eu> wrote:
> >> i2c driver is used for LE/BE that's why is useful to use
> >> 32bit accesses. Then it is not necessary to solve any
> >> endian issues.
> > 
> > Are you sure?  I would expect the BE version needs to use
> > io{read,write}32be variants of the accessors.  What platforms have you
> > tested on?
> 
> iowrite32 is the same with iowrite32be for Microblaze.
> I have no problem to change it to iowrite32be if you like.
> 
> I have tested it on microblaze big and little endian platforms.

I think what Grant was saying is that iowrite32 being the same as
iowrite32be is a bug, because iowrite32 is documented to be little-endian.

This is probably fine as long as you don't have any PCI devices,
but if you ever get PCI support, it won't work.

Also, it heavily confuses other developers such as Grant and me
if one architecture defines things to mean something completely
different from the other architectures.

	Arnd
