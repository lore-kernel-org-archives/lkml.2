Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab1I3UPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 16:15:25 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37037 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab1I3UPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 16:15:24 -0400
Subject: Re: [PATCH 2/2] mm: restrict access to /proc/meminfo
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm00@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, Kees Cook <kees@ubuntu.com>,
        Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110930130353.0da54517.akpm00@gmail.com>
References: <20110927175453.GA3393@albatros>
	 <20110927175642.GA3432@albatros> <20110927193810.GA5416@albatros>
	 <20110928144614.38591e97.akpm00@gmail.com> <20110930195329.GA2020@albatros>
	 <20110930130353.0da54517.akpm00@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 13:15:14 -0700
Message-ID: <1317413714.16137.666.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I stuck a printk in there.  It's not exactly called 100x a second, but
there were 5 distinct users just for me to boot and ssh in:

[    3.130408] meminfo read called by: 'udevd' 1
[    3.326649] meminfo read called by: 'dhclient-script' 2
[    4.624943] meminfo read called by: 'klogd' 3
[    8.008019] meminfo read called by: 'dhclient-script' 4
[    8.083091] meminfo read called by: 'ps' 5
[   48.171038] meminfo read called by: 'bash' 6

Granted, those were likely privileged.  But, that's a good list of
processes that I would rather not see break.

-- Dave

