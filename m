Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab1CIMrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 07:47:04 -0500
Received: from ozlabs.org ([203.10.76.45]:50286 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab1CIMrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 07:47:01 -0500
Date: Wed, 9 Mar 2011 23:46:57 +1100
From: Anton Blanchard <anton@samba.org>
To: =?ISO-8859-1?B?QW3pcmljbw==?= Wang <xiyou.wangcong@gmail.com>
Cc: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be
 overridden
Message-ID: <20110309234657.264d3080@kryten>
In-Reply-To: <20110309122046.GC16951@cr0.redhat.com>
References: <20100825002258.GD28360@kryten>
	<m139u37cii.fsf@fess.ebiederm.org>
	<4D771EE6.5050404@linux.vnet.ibm.com>
	<20110309122046.GC16951@cr0.redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> The crashkernel region is specified via kernel cmdline, so why
> not just drop a failure when it overlaps with RMO region?
> Am I missing something?

Unfortunately a ppc64 kernel requires a chunk of RMO memory. We would
need the ability to specify multiple crashkernel regions - about 32MB
in the RMO and the rest can be anywhere. That sounds pretty fragile for
a user to configure successfully on the cmdline.

Thats why the ppc64 crashkernel region begins mid way through the RMO
region. It means both kernels get a chunk of RMO and we only have to
deal with one crashkernel reservation in all the tools and
documentation.

Anton
