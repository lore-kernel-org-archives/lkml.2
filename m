Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab0JUBii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:38:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:64041 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0JUBih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:38:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,214,1286175600"; 
   d="scan'208";a="338592101"
Date: Thu, 21 Oct 2010 09:38:33 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "hpa@zytor.com" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>
Subject: Re: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
Message-ID: <20101021013833.GA21863@sli10-conroe.sh.intel.com>
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>
 <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi hpa,
On Thu, Oct 21, 2010 at 07:06:59AM +0800, tip-bot for Shaohua Li wrote:
> [ hpa: moved it *after* the page-aligned section, for obvious
>   reasons. ]
move it after page-aligned section can't guarantee to avoid cache false sharing.
we need:
. = ALIGN(CACHE_LINE_SIZE);
*(.data..percpu..readmostly)
. = ALIGN(CACHE_LINE_SIZE);
To make sure before/after readmostly section doesn't share cache line with
others. The headcache is some arch need L1_CACHE_SIZE and others need
(1 << INTERNODE_CACHE_SHIFT). We need change all ARCHs to make this happen.
