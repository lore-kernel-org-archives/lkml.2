Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab1EJQ5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:57:43 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37571 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1EJQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:57:41 -0400
Date: Tue, 10 May 2011 18:57:28 +0200
From: Borislav Petkov <bp@amd64.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mikew@google.com" <mikew@google.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] pstore: EFI Support
Message-ID: <20110510165728.GC3347@gere.osrc.amd.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C16FB4712@USINDEVS01.corp.hds.com>
 <20110510161137.GA14522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510161137.GA14522@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 09:11:37AM -0700, Greg KH wrote:
> On Tue, May 10, 2011 at 11:00:44AM -0400, Seiji Aguchi wrote:
> > Description of boot paremeters is following.
> > 
> >  - efi_pstore_enable
> >    enable EFI support of pstore.
> > 
> >  - efi_pstore_len
> >    Sets the buffer size of EFI variable space used by pstore.
> 
> Please don't add new boot parameters if at all possible.  Distros will
> not know to enable them, and users don't know how to either.
> 
> Use sane defaults, and provide ways to override them if needed, but
> don't rely on them for new functionality if at all possible.
> 
> Why would this option ever _not_ be something that should be enabled?

Right, so if I understand this correctly, we want actually to _switch_
to the EFI method if it is safer than APEI. So it should work like this:
if the pstore detects that the system has EFI, it should switch to use
it as a method for writing persistent records to NVRAM.

Btw, is this case of the possibility for APEI of corrupting NVRAM
storage something you actually experienced on a real machine or simply a
conclusion from looking at APEI code doing ioremap()?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
