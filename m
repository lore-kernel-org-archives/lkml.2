Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030396Ab2COOt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:49:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2COOtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:49:22 -0400
Date: Thu, 15 Mar 2012 10:49:14 -0400
From: Dave Jones <davej@redhat.com>
To: Petr =?utf-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Cc: Yang Bai <hamo.by@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>, kernel@tesarici.cz
Subject: Re: inode->i_wb_list corruption.
Message-ID: <20120315144914.GB5409@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Petr =?utf-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>,
	Yang Bai <hamo.by@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	kernel@tesarici.cz
References: <201203152208.04168.petr@tesarici.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201203152208.04168.petr@tesarici.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:08:03PM +0800, Petr Tesařík wrote:

 > > i915_drm_thaw is a deep nest of functions though, so this is going to be
 > > hard to track down where that write is coming from. Because the corruption
 > > seems to happen to pages that are already allocated, we probably can't
 > > even rely on DEBUG_PAGEALLOC, though it might be worth trying.
 > 
 > If it you believe it could be written by the CPU, I can try to catch the 
 > instruction that writes to this memory. My plan is as follows:

Given that the corruption pattern looks like pixel data, it's likely that
the writing is being done by the GPU, not the CPU, so debug registers
won't trap it.

	Dave
 
