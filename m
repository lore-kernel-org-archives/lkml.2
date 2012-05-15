Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab2EOQwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:52:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55550 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964815Ab2EOQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:52:09 -0400
Message-ID: <1337100727.7050.17.camel@joe2Laptop>
Subject: Re: [PATCH] x86: Fix boot on Twinhead H12Y
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 09:52:07 -0700
In-Reply-To: <20120515174347.5109.94551.stgit@bluebook>
References: <20120515174347.5109.94551.stgit@bluebook>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 18:44 +0100, Alan Cox wrote:
> Despite lots of investigation into why this is needed we don't know or have
> an elegant cure. The only answer found on this laptop is to mark a problem
> region as used so that Linux doesn't put anything there.

trivia:

> diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
[]
> @@ -519,3 +519,22 @@ static void sb600_disable_hpet_bar(struct pci_dev *dev)
[]
> +static void __devinit twinhead_reserve_killing_zone(struct pci_dev *dev)
> +{
> +        if (dev->subsystem_vendor == 0x14FF && dev->subsystem_device ==
> +                                        0xA003) {

Doesn't this look ugly to you?
Doesn't 

	if (dev->subsystem_vendor == 0x14FF &&
	    dev->subsystem_device == 0xA003) {

at least read more easily?


