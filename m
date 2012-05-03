Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab2ECVho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:37:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:47121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2ECVhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:37:43 -0400
Message-ID: <1336081048.6509.26.camel@twins>
Subject: Re: [PATCH 6/9] perf: Generic pci uncore device support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com, jolsa@redhat.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 23:37:28 +0200
In-Reply-To: <1335924440-11242-7-git-send-email-zheng.z.yan@intel.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
	 <1335924440-11242-7-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 10:07 +0800, Yan, Zheng wrote:
> +       if (box->pci_dev) {
> +               hwc->config_base = uncore_pci_event_ctl(box,
> hwc->idx);
> +               hwc->event_base =  uncore_pci_perf_ctr(box, hwc->idx);
> +       } else {
> +               hwc->config_base = uncore_msr_event_ctl(box,
> hwc->idx);
> +               hwc->event_base =  uncore_msr_perf_ctr(box, hwc->idx);
> +       } 

Since box is already an argument to uncore_*_event_ct[lr]() it could
include this conditional. Is GCC smart enough to pull it out and not
evaluate the condition twice in that case?


