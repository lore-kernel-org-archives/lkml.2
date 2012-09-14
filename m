Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab2INPkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:40:49 -0400
Received: from mail.x86-64.org ([217.9.48.20]:42383 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757859Ab2INPkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:40:47 -0400
Date: Fri, 14 Sep 2012 17:40:44 +0200
From: Borislav Petkov <bp@amd64.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
Message-ID: <20120914154044.GD8789@aftab.osrc.amd.com>
References: <20120912153016.GA12103@aftab.osrc.amd.com>
 <5050AC2E.3050408@akamai.com>
 <20120912154943.GB12103@aftab.osrc.amd.com>
 <5050B708.5020308@akamai.com>
 <20120912164843.GC12103@aftab.osrc.amd.com>
 <5050BF1F.1080503@akamai.com>
 <20120912170629.GD12103@aftab.osrc.amd.com>
 <20120912172351.GE12103@aftab.osrc.amd.com>
 <50532940.10201@akamai.com>
 <50534184.1050208@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50534184.1050208@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 09:39:00AM -0500, Josh Hunt wrote:
> On 09/14/2012 07:55 AM, Josh Hunt wrote:
> >
> >Thanks to your help I was able to test your branch, but it still does
> >not resolve the problem. Removal of the "factor=1" workaround fixes the
> >memory size reporting on boot, but the sysfs values are still incorrect.
> >
> 
> Please disregard what I said earlier about the shift still being
> wrong. Looking at the dmesg more I see now that the # of pages are
> correctly reported (262144), however sysfs is still wrong.
> 
> [   25.837588] EDAC DEBUG: init_csrows: MC node: 0, csrow: 0
> [   25.837589] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 0, channel:
> 0, DBAM idx: 2
> [   25.837591] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   25.837592] EDAC amd64: CS0: Unbuffered DDR2 RAM
> [   25.837724] EDAC DEBUG: init_csrows: Total csrow0 pages: 262144
> [   25.837725] DBG: init_csrows: channel_count:2
> [   25.837856] DBG: init_csrows: channel_count:2
> [   25.837988] EDAC DEBUG: init_csrows: MC node: 0, csrow: 1
> [   25.837989] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 1, channel:
> 0, DBAM idx: 2
> [   25.837991] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   25.837992] EDAC amd64: CS1: Unbuffered DDR2 RAM
> [   25.838157] EDAC DEBUG: init_csrows: Total csrow1 pages: 262144
> [   25.838158] DBG: init_csrows: channel_count:2
> [   25.838289] DBG: init_csrows: channel_count:2
> [   25.838421] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
> [   25.838422] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel:
> 0, DBAM idx: 2
> [   25.838424] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   25.838425] EDAC amd64: CS2: Unbuffered DDR2 RAM
> [   25.838556] EDAC DEBUG: init_csrows: Total csrow2 pages: 262144
> [   25.838558] DBG: init_csrows: channel_count:2
> [   25.838689] DBG: init_csrows: channel_count:2
> [   25.838820] EDAC DEBUG: init_csrows: MC node: 0, csrow: 3
> [   25.838822] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel:
> 0, DBAM idx: 2
> [   25.838823] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
> [   25.838824] EDAC amd64: CS3: Unbuffered DDR2 RAM
> [   25.838957] EDAC DEBUG: init_csrows: Total csrow3 pages: 262144
> 
> I looked into this and see that sysfs is doing the double counting
> b/c it loops over the # of channels:
> 
> [  131.423949] DBG: csrow_size_show: i:0 nr_pages:262144 nr_channels:2
> [  131.424112] DBG: csrow_size_show: i:1 nr_pages:524288 nr_channels:2
> 
> I verified this in init_csrows:
> [   25.838958] DBG: init_csrows: channel_count:2
> 
> Since I don't know the details of the hardware here it's hard for me
> to suggest a fix, but it would seem that k8_early_channel_count()
> needs to be modified to only return 1 in this case?

Yeah, there are still some issues after the whole change to per-dimm
accounting came in. I'm looking into it.

Thanks for testing and reporting. If you see anything else out of the
ordinary, let me know too so that I can fix it.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
