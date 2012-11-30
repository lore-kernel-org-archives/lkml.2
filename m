Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2K3Uka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:40:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:48573 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757087Ab2K3Uk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:40:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,194,1355126400"; 
   d="scan'208";a="257323341"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v2 01/10] Documentation/x86: Early load microcode
Thread-Topic: [PATCH v2 01/10] Documentation/x86: Early load microcode
Thread-Index: AQHNztec7t04HXDVJEWLAFC5kNl3w5gDTyGA//+H2bA=
Date: Fri, 30 Nov 2012 20:40:24 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712203AE0B90F@ORSMSX105.amr.corp.intel.com>
References: <1354240068-9821-1-git-send-email-fenghua.yu@intel.com>
 <1354240068-9821-2-git-send-email-fenghua.yu@intel.com>
 <50B90D05.2030002@zytor.com>
In-Reply-To: <50B90D05.2030002@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Friday, November 30, 2012 11:46 AM
> To: Yu, Fenghua
> Cc: Ingo Molnar; Thomas Gleixner; Mallick, Asit K; Tigran Aivazian;
> Andreas Herrmann; Borislav Petkov; linux-kernel; x86
> Subject: Re: [PATCH v2 01/10] Documentation/x86: Early load microcode
> 
> On 11/29/2012 05:47 PM, Fenghua Yu wrote:
> > +
> > +mkdir initrd
> > +cd initrd
> > +cp ../microcode.hex kernel/x86/microcode/GenuineIntel/microcode.hex
> > +find .|cpio -oc >../ucode.cpio
> > +cd ..
> > +cat ucode.cpio /boot/initrd-3.5.0.img >/boot/initrd-3.5.0.ucode.img
> > +
> > +The generated /boot/initrd-3.5.0.ucode.img can be used as initrd
> file to load
> > +microcode during early boot time.
> >
> 
> This is wrong; first of all, this refers to microcode.hex whereas the
> patch refers to microcode.bin, and 

Will fix this sentence. 

> it misses the mandatory -H newc
> option to cpio.

I think there is no problem here. "-c" is "-H newc".

Quote from man cpio:
'-c' Identical to -H newc, use the new (SVR4) portable format.  If you wish the old
       portable (ASCII) archive format, use -H odc instead.

> 
> Could you update this bit, please?
> 
> 	-hpa

