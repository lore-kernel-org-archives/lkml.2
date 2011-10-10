Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1JJQNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:13:23 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47727 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751276Ab1JJQNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:13:22 -0400
Message-ID: <1318263201.25811.24.camel@Joe-Laptop>
Subject: Re: [PATCH 1/1] drivers: staging: rts_pstor fixed checkpatch
 warnings
From: Joe Perches <joe@perches.com>
To: Pelle Windestam <pelle@windestam.se>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 09:13:21 -0700
In-Reply-To: <CAOdCkm1YNJ2xkVk+p1MTxX_e_5T8UM9Tz7mWE5v5JUhHOuenEg@mail.gmail.com>
References: <1318225337-25438-1-git-send-email-pelle@windestam.se>
	 <20111010075250.GY18470@longonot.mountain>
	 <CAOdCkm1YNJ2xkVk+p1MTxX_e_5T8UM9Tz7mWE5v5JUhHOuenEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 17:14 +0200, Pelle Windestam wrote:
> On Mon, Oct 10, 2011 at 9:52 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > This looked nicer in the original version.  I know that checkpatch
> > complains but in the end, checkpatch is just a perl script.  It's
> > less sentient than a squirrel.

I agree.

That's good happy cheery imagery Dan,
but I might have chosen a cockroach too.

> I have to agree with you on that, but I wasn't sure how strictly to
> follow the checkpatch warnings. I'll happily resubmit the patch
> without this change if nobody minds.
 
> -static struct pci_device_id rtsx_ids[] = {
> -	{ 0x10EC, 0x5208, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_OTHERS << 16, 0xFF0000 },
> -	{ 0x10EC, 0x5209, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_OTHERS << 16, 0xFF0000 },
> -	{ 0x10EC, 0x5288, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_OTHERS << 16, 0xFF0000 },
> +static DEFINE_PCI_DEVICE_TABLE(rtsx_ids) = {
> +	{ 0x10EC, 0x5208, PCI_ANY_ID, PCI_ANY_ID,
> +	  PCI_CLASS_OTHERS << 16, 0xFF0000 },
> +	{ 0x10EC, 0x5209, PCI_ANY_ID, PCI_ANY_ID,
> +	  PCI_CLASS_OTHERS << 16, 0xFF0000 },
> +	{ 0x10EC, 0x5288, PCI_ANY_ID, PCI_ANY_ID,
> +	  PCI_CLASS_OTHERS << 16, 0xFF0000 },
>  	{ 0, },

Maybe use PCI_DEVICE

static DEFINE_PCI_DEVICE_TABLE(rtsx_ids) = {
	{ PCI_DEVICE(0x10EC, 0x5208), PCI_CLASS_OTHERS << 16, 0xFF0000 },
	{ PCI_DEVICE(0x10EC, 0x5209), PCI_CLASS_OTHERS << 16, 0xFF0000 },
	{ PCI_DEVICE(0x10EC, 0x5288), PCI_CLASS_OTHERS << 16, 0xFF0000 },
	{ 0, },

You could also substitute PCI_VENDOR_ID_REALTEK for 0x10ec


