Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab0DRXto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 19:49:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:55642 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0DRXtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 19:49:43 -0400
Date: Sun, 18 Apr 2010 16:51:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jan =?UTF-8?B?S3VuZHLDoXQ=?= <jkt@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: boot device order troubleshooting without an initrd
Message-ID: <20100418165125.1d2b2843@infradead.org>
In-Reply-To: <4BCB87E2.4090807@gentoo.org>
References: <4BCB87E2.4090807@gentoo.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 00:29:54 +0200
Jan Kundrát <jkt@gentoo.org> wrote:

> Hi folks,
> I'm looking for a way to pass a correct "root" parameter to the kernel
> from the bootloader, independently on the number of attached disks. My
> machine (VIA EPIA SN-1800) has four SATA ports and one CF card slot.
> The CF slot is visible as an IDE device. The BIOS is configured for
> booting from the CF card, and Grub2 has absolutely no problems
> booting the kernel.
> 
> The problem I'm facing is that if there are no SATA disks attached, my
> CF card gets called /dev/sda, while if I attach two SATA drives, the
> CF card gets called /dev/sdc. I can solve that "in userspace" without


so the problem is that the boot order you want is pretty much opposite
from what "normal" people want.
AHCI sata before CF slots is pretty much the right thing and what most
people will use.... most people will have their OS on AHCI SATA, and
occasionally stick in some photo card or whatever.... and they'd ask
the flipside question basically.


We could have pretty evil things in the kernel, so that we'd deal with
multiple root= lines in the kernel, one by one trying them until one
sticks. Right now we don't.... but if you make a clean enough patch
it might even pass the review here...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
