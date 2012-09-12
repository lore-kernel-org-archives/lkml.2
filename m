Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2ILPt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:49:56 -0400
Received: from mail.x86-64.org ([217.9.48.20]:55626 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2ILPto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:49:44 -0400
Date: Wed, 12 Sep 2012 17:49:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Josh Hunt <johunt@akamai.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
Message-ID: <20120912154943.GB12103@aftab.osrc.amd.com>
References: <1347403947-20187-1-git-send-email-johunt@akamai.com>
 <504FC2E9.4010708@akamai.com>
 <20120912085140.GA12277@aftab.osrc.amd.com>
 <5050824B.9050006@akamai.com>
 <5050857F.5060207@akamai.com>
 <20120912153016.GA12103@aftab.osrc.amd.com>
 <5050AC2E.3050408@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5050AC2E.3050408@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:37:18AM -0500, Josh Hunt wrote:
> Well from what I see 603ad... would only fix the case of printing the
> values correctly on boot, by removing the factor=1 shift. However,
> that is merely cosmetic as it does not affect the actual calculation
> of nr_pages. I guess maybe I wasn't completely clear before, but I
> see the doubling of the amount of memory both on boot via dmesg, but
> also in /sys/devices/system/edac/mc/mc0/size_mb and all of the csrow*
> subdirs therein.

Yes, that's because the whole init_csrows thing has been b0rked since
forever. In your case, amd64_csrow_nr_pages() should pay attention to
the dct (second argument) which on K8 is always 0 (we have only one DCT
aka Dram ConTroller on K8) and the function should return 0 if dct is 1.
But the whole loop in init_csrows is fishy too so I'll need to rework
that properly. Oh well...

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
