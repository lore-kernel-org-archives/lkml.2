Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0IVWGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:06:13 -0400
Received: from quartz.orcorp.ca ([139.142.54.143]:39258 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0IVWGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:06:12 -0400
Date: Wed, 22 Sep 2010 16:06:11 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>
Subject: Re: [PATCH 2/2] siw: Add support for CRC32C offload instruction
	using libcrypto crc32c-intel
Message-ID: <20100922220611.GL11157@obsidianresearch.com>
References: <1285187425-10950-1-git-send-email-nab@linux-iscsi.org> <4C9A698B.90806@linux.intel.com> <1285187901.1849.85.camel@haakon2.linux-iscsi.org> <20100922205943.GI11157@obsidianresearch.com> <1285189241.1849.112.camel@haakon2.linux-iscsi.org> <20100922211808.GJ11157@obsidianresearch.com> <1285191511.1849.126.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285191511.1849.126.camel@haakon2.linux-iscsi.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 02:38:31PM -0700, Nicholas A. Bellinger wrote:

> So I think the main bit here is the ability to request
> crc32c-intel.ko first, and then fall back to crc32c.ko when the
> former is not available on CONFIG_X86.

Well, it is what Andi said, everything is working fine but there is no
mechanism to autoload the accelerated crypto module. If you did
modprobe crc32c_intel prior to loading your driver it would
automatically get crc32c-intel when it asks for crc32c since it is
loaded and a higher priority.

So, the drivers are correct to just request crc32c .. The work around
to limited autoprobing is so trivial (modprob crc32_intel) I'm not
sure including extra autoprobing code in the drivers is worthwhile?

Jason
