Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1FFJCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:02:01 -0400
Received: from mx0.aculab.com ([213.249.233.131]:57236 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753098Ab1FFJB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:01:58 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH] powerpc: Use the #address-cells information to parsememory/reg
Date: Mon, 6 Jun 2011 10:00:22 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AD73@saturn3.aculab.com>
In-Reply-To: <4DEC7F49.8060000@in.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [RFC][PATCH] powerpc: Use the #address-cells information to parsememory/reg
thread-index: AcwkGdh41d7s4Xw+T8G/EQoASA7q2wADaEPA
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Suzuki Poulose" <suzuki@in.ibm.com>, "Simon Horman" <horms@verge.net.au>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        <kexec@lists.infradead.org>, "lkml" <linux-kernel@vger.kernel.org>,
        "linux ppc dev" <linuxppc-dev@lists.ozlabs.org>,
        "Vivek Goyal" <vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Changed the add_usable_mem_property() to accept FILE* fp instead of
int fd,
> > as most of the other users of read_memory_region_limits() deals with
FILE*.
> >
> > Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
> 
> Could you please let me know your thoughts/comments about this patch ?

Is the change to use 'FILE *' actually progress?
I'd have thought that the randomly aligned read/lseek system calls
that this allows to happen are not desirable for anything that
isn't a true file.

I'd also suggest that the sizeof's should be applied to the
actual type of the variable being read/written, not arbitrarily
'long' or 'int', and this probably ought to be some fixed size type.

	David


