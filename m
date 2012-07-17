Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2GQMe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:34:26 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:38001 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab2GQMeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:34:21 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJji0PEBZF
X-RZG-CLASS-ID: mo00
Date: Tue, 17 Jul 2012 14:34:18 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Keir Fraser <keir.xen@gmail.com>, xen-devel@lists.xensource.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S during
 kexec boot
Message-ID: <20120717123418.GA28781@aepfle.de>
References: <20120710180953.GB20075@aepfle.de>
 <CC223C2F.3817C%keir.xen@gmail.com>
 <20120715160653.GA22779@aepfle.de>
 <20120716154647.GC13540@phenom.dumpdata.com>
 <20120717102456.GA8197@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120717102456.GA8197@aepfle.de>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, Olaf Hering wrote:

To make this robust against allocation errors I will change it to

       do {

> +	/* Allocate new mfn for previous pfn */
> +	rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);

       } while (rc == 0);

> +
> +	/* Make sure the previous pfn is really connected to a (new) mfn */
> +	BUG_ON(rc != 1);

Olaf
