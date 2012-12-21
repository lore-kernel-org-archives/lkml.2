Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2LUPKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:10:00 -0500
Received: from mga03.intel.com ([143.182.124.21]:33103 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab2LUPJy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:09:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,329,1355126400"; 
   d="scan'208";a="235206205"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Michael Tokarev <mjt@tls.msk.ru>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH v4 00/11] x86/microcode: Early load microcode
Thread-Topic: [PATCH v4 00/11] x86/microcode: Early load microcode
Thread-Index: AQHN3yYCQ/bcxrK+PE6MEAAEcNf0cZgjfDgA///bMAA=
Date: Fri, 21 Dec 2012 15:09:48 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122047109B7E@ORSMSX105.amr.corp.intel.com>
References: <1356032893-2730-1-git-send-email-fenghua.yu@intel.com>
 <50D42626.40708@msgid.tls.msk.ru>
In-Reply-To: <50D42626.40708@msgid.tls.msk.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Michael Tokarev [mailto:mjt@tls.msk.ru]
> Sent: Friday, December 21, 2012 1:05 AM
> To: Yu, Fenghua
> Cc: H Peter Anvin; Ingo Molnar; Thomas Gleixner; Mallick, Asit K;
> Tigran Aivazian; Yinghai Lu; Andreas Herrmann; Borislav Petkov; linux-
> kernel; x86
> Subject: Re: [PATCH v4 00/11] x86/microcode: Early load microcode
> 
> On 20.12.2012 23:48, Fenghua Yu wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > The problem in current microcode loading method is that we load a
> microcode way,
> > way too late; ideally we should load it before turning paging on.
> This may only
> > be practical on 32 bits since we can't get to 64-bit mode without
> paging on,
> > but we should still do it as early as at all possible.
> 
> Why loading microcode this early is important?
> Why it is bad to load it at the end of (initial) boot?
> 
> Thanks,
> 
> /mjt

If not loading microcode early, we may hit some issues (e.g. PSE on Atom) and disable some CPU features. These issues can not be fixed by loading ucode during run time.

Thanks.

-Fenghua
