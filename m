Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab1GFE16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 00:27:58 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39991 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1GFE15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 00:27:57 -0400
Date: Wed, 6 Jul 2011 09:57:44 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-mm@kvack.org, svaidy@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] mm,debug: VM framework to capture memory reference
 pattern
Message-ID: <20110706042744.GA15861@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1309854159-8277-1-git-send-email-ankita@in.ibm.com>
 <64797.1309908804@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64797.1309908804@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 05, 2011 at 07:33:24PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 05 Jul 2011 13:52:34 +0530, Ankita Garg said:
> 
> > by default) and scans through all pages of the specified tasks (including
> > children/threads) running in the system. If the hardware reference bit in the
> > page table is set, then the page is marked as accessed over the last sampling
> > interval and the reference bit is cleared.
> 
> Does that cause any issues for other code in the mm subsystem that was
> expecting to use the reference bit for something useful? (Similarly, if other
> code in mm turns that bit *off* for its own reasons, does your code still
> produce useful results?)

At this point, the VM code does not use the reference bit for any
decision making, not even in the LRU. However, if the reference bit is
used later on, then this change will interfere with that logic.

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
