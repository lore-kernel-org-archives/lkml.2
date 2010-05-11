Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0EKSwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:52:38 -0400
Received: from mga05.intel.com ([192.55.52.89]:25437 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752152Ab0EKSwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:52:37 -0400
Message-Id: <89kc63$grv1m8@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,209,1272870000"; 
   d="scan'208";a="566200008"
Date: Tue, 11 May 2010 19:52:31 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: DRM Error on Acer Aspire One
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>, Eric Anholt <eric@anholt.net>,
       Ingo Molnar <mingo@elte.hu>
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com> <89kc63$grtht6@fmsmga002.fm.intel.com> <20100511104818.8382a7de.akpm@linux-foundation.org> <89khjo$fd26d3@orsmga002.jf.intel.com> <20100511113555.a78c9c8e.akpm@linux-foundation.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100511113555.a78c9c8e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 11:35:55 -0400, Andrew Morton <akpm@linux-foundation.org> wrote:
> No, io_mapping_map_atomic_wc() cannot be used from [soft]irq context:
> it hardwires use of KM_USER0.  I suggest that io_mapping_create_wc(),
> io_mapping_map_atomic_wc() etc be changed so that the caller passes in the
> KM_foo kmap slot index.

Argh, sorry for the noise, read the mail in the wrong order. Thanks for
the review. It would be sensible to go with your simpler patch whilst
io_mapping_map_atomic_wc() is improved.

-- 
Chris Wilson, Intel Open Source Technology Centre
