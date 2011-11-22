Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab1KVWst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:48:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:65163 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab1KVWss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:48:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="78968731"
Date: Tue, 22 Nov 2011 23:00:19 +0000
From: Alan Cox <alan@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Rubini <ru@gnudd.com>, fujita.tomonori@lab.ntt.co.jp,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        maddalena.brattoli@st.com
Subject: Re: a question on DMA and remapping
Message-ID: <20111122230019.3304ecdf@bob.linux.org.uk>
In-Reply-To: <20111117154729.afa24f07.akpm@linux-foundation.org>
References: <20111117233059.GA659@mail.gnudd.com>
	<20111117154729.afa24f07.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Generalising the existing code to cover more cases isn't a bad thing
> to do.  Others might be able to use it, and they surely won't be able
> to use any cloned-and-owned swiotlb.c.

If you look on the kernel list there has also been some discussion and
work recently towards removing a lot of the duplication between the
iommu devices.

I think really you need to be an actual iommu instance because in
reality you are. Trying to fudge it any other way breaks the moment
someone tries to do a device to device DMA transfer because your
bus/phys mapping seen from your device and the bus/phys mapping seen
from another device into your device do not match as I understand it.

Alan
