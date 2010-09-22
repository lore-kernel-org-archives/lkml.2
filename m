Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0IVU7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:59:49 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:42173 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab0IVU7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:59:47 -0400
Date: Wed, 22 Sep 2010 14:59:43 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andi Kleen <ak@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>,
        David Miller <davem@davemloft.net>,
        Matthew Wilcox <willy@linux.intel.com>,
        Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/2] siw: Add support for CRC32C offload instruction
	using libcrypto crc32c-intel
Message-ID: <20100922205943.GI11157@obsidianresearch.com>
References: <1285187425-10950-1-git-send-email-nab@linux-iscsi.org> <4C9A698B.90806@linux.intel.com> <1285187901.1849.85.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285187901.1849.85.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 01:38:21PM -0700, Nicholas A. Bellinger wrote:

> Indeed, this would clean up the explict RX/TX CRC32C case quite a
> bit..  Unfortuately I am too busy with other items atm to cook up
> this patch, but I would be happy to test it if someone wants to take
> it.  ;)

Do you even need to do anything at all? crc32c is provided by
crc32c-intel at a higher priority already, so it should be used if it
is available..
 
> > Need CPUID module auto probing. I have an older patch that needs
> > some fixes.

> Hmm, I don't see how that fits in here exactly.  Would you mind
> elaborating a bit..?

Unless the module is loaded the optimized algorithm will not be
available for automatic use. Maybe your patch causes it to autoload
because of the by-name reference? Identifying modules to load by CPUID
will let userspace auto load the appropriate ones based on CPU...

Jason
