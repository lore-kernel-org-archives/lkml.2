Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1CQAGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:06:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22541 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1CQAGq (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Mar 2011 20:06:46 -0400
Date: Wed, 16 Mar 2011 20:00:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Mike Waychison <mikew@google.com>, Wim Van Sebroeck <wim@iguana.be>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-watchdog@vger.kernel.org, Priyanka Gupta <priyankag@google.com>
Subject: Re: [PATCH] watchdog, SP5100: Check if firmware has set correct
 value in tcobase.
Message-ID: <20110317000035.GA3613@dumpdata.com>
References: <alpine.DEB.2.00.1103111201470.2968@kaball-desktop>
 <20110311222129.GA3168@dumpdata.com>
 <alpine.DEB.2.00.1103161150010.3382@kaball-desktop>
 <alpine.DEB.2.00.1103161442210.3382@kaball-desktop>
 <4D80F992.10603@kernel.org>
 <alpine.DEB.2.00.1103161757040.3382@kaball-desktop>
 <4D812180.5030102@kernel.org>
 <AANLkTimNva3c_-kGA+JLCPZgrKAbwqLKaN559cwTh7cq@mail.gmail.com>
 <4D812919.30706@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D812919.30706@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D81505D.0098,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 02:18:17PM -0700, Yinghai Lu wrote:
> 
> 
> Stefano found SP5100 TCO watchdog driver using wrong address.
> 
> [    9.148536] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
> [    9.148628] DEBUG __ioremap_caller WARNING address=b8fe00 size=8 valid=1 reserved=1
> 
> and e820 said that range is RAM.
> 
> We should check if we can use that reading out. BIOS could just program wrong address there.
> 
> -v2: Mike pointed out one path need one release.
> 
> Reported-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by:Yinghai Lu <yinghai@kernel.org>
> Acked-by: Mike Waychison <mikew@google.com>

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Stefano,

this fixes my bootup issues with your:
xen: set max_pfn_mapped to the last pfn mapped
patch. Will try the full patchset tomorrow.
