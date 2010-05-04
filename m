Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083Ab0EDSEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:04:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:39151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757881Ab0EDSEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:04:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,328,1270450800"; 
   d="scan'208";a="618830732"
Subject: Re: [PATCH 1/2] x86: eliminate TS_XSAVE
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Cui, Dexuan" <dexuan.cui@intel.com>, Sheng Yang <sheng@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
In-Reply-To: <1272812038-32484-2-git-send-email-avi@redhat.com>
References: <1272812038-32484-1-git-send-email-avi@redhat.com>
	 <1272812038-32484-2-git-send-email-avi@redhat.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 04 May 2010 11:03:29 -0700
Message-Id: <1272996209.2833.1.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-02 at 07:53 -0700, Avi Kivity wrote:
> The fpu code currently uses current->thread_info->status & TS_XSAVE as
> a way to distinguish between XSAVE capable processors and older processors.
> The decision is not really task specific; instead we use the task status to
> avoid a global memory reference - the value should be the same across all
> threads.
> 
> Eliminate this tie-in into the task structure by using an alternative
> instruction keyed off the XSAVE cpu feature; this results in shorter and
> faster code, without introducing a global memory reference.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

