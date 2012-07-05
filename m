Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab2GENym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:54:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27390 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab2GENyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:54:40 -0400
Date: Thu, 5 Jul 2012 16:54:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org
Subject: potential off by one in vdso reloc_symtab()
Message-ID: <20120705135425.GA21466@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

I'm doing an audit for off by one errors and I had a question about
the code in reloc_symtab().

arch/x86/vdso/vdso32-setup.c
    86          for(i = 0; i < nsym; i++, sym++) {
    87                  if (sym->st_shndx == SHN_UNDEF ||
    88                      sym->st_shndx == SHN_ABS)
    89                          continue;  /* skip */
    90  
    91                  if (sym->st_shndx > SHN_LORESERVE) {
                                          ^^^^^^^^^^^^^^^

Should this be >= SHN_LORESERVE?  The other comparisons with
SHN_LORESERVE put == SHN_LORESERVE together with the >.

    92                          printk(KERN_INFO "VDSO: unexpected st_shndx %x\n",
    93                                 sym->st_shndx);
    94                          continue;
    95                  }

regards,
dan carpenter

