Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1CJQ57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:57:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:7688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab1CJQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:57:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,297,1297065600"; 
   d="scan'208";a="611385151"
Date: Thu, 10 Mar 2011 08:57:30 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
Message-ID: <20110310165730.GC20504@alboin.amr.corp.intel.com>
References: <20110308164508.GA8729@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308164508.GA8729@darkside.kls.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 05:45:08PM +0100, Mario 'BitKoenig' Holbe wrote:
> Hello,
> 
> dm-crypt in 2.6.38 changed to per-CPU workqueues to increase it's
> performance by parallelizing encryption to multiple CPUs.
> This modification seems to cause (massive) performance drops for
> multiple parallel dm-crypt instances...
> 
> I'm running a 4-disk RAID0 on top of 4 independent dm-crypt(aes-xts)
> devices on a Core2Quad 3GHz. This setup did overcome the single-CPU
> limitation from previous versions and utilized all 4 cores for
> encryption.
> The throughput of this array drops from 282MB/s sustained read (dd,
> single process) with 2.6.37.3 down to 133MB/s with 2.6.38-rc8 (which

It will be better with multiple processes running on different CPUs. 
The new design is really for multiple processes.

Do you actually use dd for production or is this just a benchmark?
(if yes: newsflash: use a better benchmark)

-Andi
