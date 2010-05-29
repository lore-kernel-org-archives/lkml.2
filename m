Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0E2Lzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 07:55:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58169 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab0E2Lzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 07:55:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Tom Lyon" <pugs@cisco.com>
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Date: Sat, 29 May 2010 13:55:11 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, mst@redhat.com, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
References: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
In-Reply-To: <4c004cba.Z/2Hpd7reetFaFC5%pugs@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005291355.11727.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19TNUZA/rpQZ8v67OqoxED/AMHDaP5dIUmFpKj
 S6YNG5igT0IL/Jqh9vEA7pxQEfA+62m3/hVZw8Nq+zicLUFyIx
 dACj1Wj3RogGHXqT5kHmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 May 2010, Tom Lyon wrote:
> +/*
> + * Structure for DMA mapping of user buffers
> + * vaddr, dmaaddr, and size must all be page aligned
> + * buffer may only be larger than 1 page if (a) there is
> + * an iommu in the system, or (b) buffer is part of a huge page
> + */
> +struct vfio_dma_map {
> +       __u64   vaddr;          /* process virtual addr */
> +       __u64   dmaaddr;        /* desired and/or returned dma address */
> +       __u64   size;           /* size in bytes */
> +       int     rdwr;           /* bool: 0 for r/o; 1 for r/w */
> +};

Please add a 32 bit padding word at the end of this, otherwise the
size of the data structure is incompatible between 32 x86 applications
and 64 bit kernels.

	Arnd
