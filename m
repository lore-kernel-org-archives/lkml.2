Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2CLQ1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:27:13 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:53191 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2CLQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:27:12 -0400
Date: Mon, 12 Mar 2012 17:26:46 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] EDAC: Convert AMD EDAC pieces to use RAS printk
 buffer
Message-ID: <20120312162646.GB7255@aftab>
References: <1331040694-12558-1-git-send-email-bp@amd64.org>
 <1331040694-12558-4-git-send-email-bp@amd64.org>
 <4F563067.1090100@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F15B61916@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F15B61916@ORSMSX103.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 04:18:57PM +0000, Luck, Tony wrote:
> > This is an initial version of the patch which converts MCE decoding
> > facilities to use the RAS printk buffer. When there's no userspace agent
> > running (i.e., /sys/devices/system/ras/agent == 0), we fall back to the
> > default printk'ing into dmesg which is what we've been doing so far.
> 
> This looks unpleasant if your userspace agent set this sysfs file, and
> then dies (or gets killed).

Yeah, having a sysfs file like that felt unpleasant - I was hoping
someone would point me to a better solution...

> Perhaps you need some device file that the agent keeps open (so if the
> agent goes away, the kernel gets a "close" on the device to tell it
> to revert). But even with this sort of solution you would still have
> to worry about races.

Sounds better, especially the close-on-exit part. Please elaborate on
the races...

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
