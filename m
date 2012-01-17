Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2AQAK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:10:57 -0500
Received: from numidia.opendz.org ([98.142.220.152]:60908 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2AQAKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:10:55 -0500
Date: Tue, 17 Jan 2012 01:14:03 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Ming Lei <tom.leiming@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>, justinmattock@gmail.com,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
Message-ID: <20120117001403.GC18875@dztty>
References: <20120116224028.GA5072@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120116224028.GA5072@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 02:40:28PM -0800, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> When suspending, there was a large list of warnings going something like:
Not only suspend, during poweroff we'll also see these annoying warnings
as reported here: http://lkml.org/lkml/2012/1/10/504

> 	Device 'machinecheck1' does not have a release() function, it is broken and must be fixed
> 
> This patch turns the static mce_devices into dynamically allocated, and
> properly frees them when they are removed from the system.  It solves
> the warning messages on my laptop here.
> 
> Reported-by: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Borislav Petkov <bp@amd64.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
> 
> Linus, this should fix the warnings on your laptop, it does on mine.
Patch tested.

Thanks, this also fixed the warnings for my KVM/Qemu guests.

-- 
tixxdz
http://opendz.org
