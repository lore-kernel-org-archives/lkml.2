Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab1KKFnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 00:43:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab1KKFna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 00:43:30 -0500
Date: Fri, 11 Nov 2011 06:44:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>,
        linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111111054419.GA2479@redhat.com>
References: <20111029171554.GA16596@nomi.cz>
 <20111031160342.GB2225@redhat.com>
 <20111109155411.GA1669@nomi.cz>
 <20111109165158.GA2254@redhat.com>
 <20111110091816.GA2247@nomi.cz>
 <CAJ-VmonOg+1G4xHjApkDwNo2GF-7pVoE7o5Vefr4Eaq5UJxM9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ-VmonOg+1G4xHjApkDwNo2GF-7pVoE7o5Vefr4Eaq5UJxM9Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 11:31:45AM -0800, Adrian Chadd wrote:
> .. are you sure it's a software use-after-free?
I'm quite sure now this is not the problem here ...

> What about "NIC DMA'ing stuff into completely incorrect space" after free? :-)
> (Or a firmware/NIC bug where it scribbles to random memory at times..)
Seems that is the reason of corruption, since CONFIG_DEBUG_PAGEALLOC doest not
catch it. I'm not sure how to debug such issues, maybe enabling IOMMU will
allow to debug? Other than trying iommu, would be good to check if problem
also happens on 64bit kernels (CONFIG_IA32_EMULATION allow to use
64bit kernel with 32bit user-space), and configure CONFIG_DMA_API_DEBUG
to see if there are any mistakes with programming DMA.

Stanislaw
