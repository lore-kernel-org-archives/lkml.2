Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab1I2R0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:26:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37531 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1I2R02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:26:28 -0400
Date: Thu, 29 Sep 2011 21:25:31 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-hardening@lists.openwall.com, Valdis.Kletnieks@vt.edu
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [kernel-hardening] Re: [PATCH 2/2] mm: restrict access to
 /proc/meminfo
Message-ID: <20110929172531.GA19290@albatros>
References: <20110927175453.GA3393@albatros>
 <20110927175642.GA3432@albatros>
 <20110927193810.GA5416@albatros>
 <alpine.DEB.2.00.1109271459180.13797@router.home>
 <alpine.DEB.2.00.1109271328151.24402@chino.kir.corp.google.com>
 <20110929161848.GA16348@albatros>
 <23921.1317315452@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <23921.1317315452@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 12:57 -0400, Valdis.Kletnieks@vt.edu wrote:
> But now he has to fly blind for the next 30 because the numbers will display
> exactly the same, and he can't correct for somebody else allocating one so he
> needs to only allocate 29...

You're still talking about "slabinfo", which is already restricted.


And meminfo can be still learned with the same race window (ala seq lock):

    prepare_stuff();
    fill_slabs(); // Here we know counters with KB granularity
    while (number_is_not_ok()) {
        prepare_stuff();
        fill_slabs();
    }
    do_exploit();


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
