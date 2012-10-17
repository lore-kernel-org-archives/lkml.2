Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2JQNJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:09:38 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43676 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab2JQNJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:09:36 -0400
Date: Wed, 17 Oct 2012 15:09:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, gong.chen@linux.intel.com, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, bp@amd64.org, lcm@us.ibm.com,
        andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, gregkh@suse.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
Message-ID: <20121017130934.GB14590@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	tony.luck@intel.com, gong.chen@linux.intel.com, ananth@in.ibm.com,
	masbock@linux.vnet.ibm.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, bp@amd64.org, lcm@us.ibm.com,
	andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
	mingo@redhat.com, gregkh@suse.de, linux-edac@vger.kernel.org
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
 <20120912122516.3825.87838.stgit@localhost.localdomain>
 <505C51D8.6070402@linux.vnet.ibm.com>
 <20121017105940.GA14590@x1.osrc.amd.com>
 <507E9622.6090606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <507E9622.6090606@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 04:57:30PM +0530, Naveen N. Rao wrote:
> On 10/17/2012 04:29 PM, Borislav Petkov wrote:
> >>>
> >>>+static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
> >>>+	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
> >>>+	&mce_bios_cmci_threshold
> >
> >Ok, I just noticed this (we must've missed it during review) but why is
> >this read-only? If it has to be read-only, why do we have a node for
> >this in sysfs instead of simply issuing the printk statements below and
> >people who are interested in this, can grep dmesg?
> 
> This was added so that user-space tools could find out if we're
> using thresholds for CMCI.

That I figured out.

What I can't figure out is why userspace tools need to know that - the
fact that some MCI_CTL2 has a 0 CMCI threshold because BIOS forgot to
set it correctly? IOW, this is a rather evolved workaround for b0rked
BIOS (the gazillionth BIOS f*ckup, btw if someone is counting :)) and,
on top of that, we have a read-only, special sysfs node which is pretty
useless to me.

Why?

-- 
Regards/Gruss,
Boris.
