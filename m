Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0ESJXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:23:39 -0400
Received: from mga12.intel.com ([143.182.124.36]:25727 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754123Ab0ESJXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:23:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,262,1272870000"; 
   d="scan'208";a="278861991"
Date: Wed, 19 May 2010 02:23:35 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>
Subject: Re: [PATCH 1/2] v4 x86/mrst: add cpu type detection
Message-ID: <20100519022335.00007d65@unknown>
In-Reply-To: <alpine.LFD.2.00.1005182250460.3368@localhost.localdomain>
References: <1274184166-17242-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1274184166-17242-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<alpine.LFD.2.00.1005182250460.3368@localhost.localdomain>
Organization: Intel OTC
X-Mailer: Claws Mail 3.7.4cvs1 (GTK+ 2.16.0; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  Aside of that wouldn't it make more sense to do the chip
>  identification only once from mrst_init() and cache the result and
>  change mrst_identify_cpu()
>
the problem is again the ordering of cpuid, boot_cpu_data is not available
by the time we call  x86_mrst_early_setup(). I can move it to mrst_time_init()
but not very ideal. Unless we go back to do cpuid directly in the v1 patch :).
