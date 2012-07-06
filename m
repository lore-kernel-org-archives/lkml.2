Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab2GFMzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:55:47 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42383 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab2GFMzq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 6 Jul 2012 08:55:46 -0400
Message-Id: <4FF6FCA9020000780008E0BB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 13:56:41 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>, "Daniel Kiper" <dkiper@net-space.pl>
Cc: <kexec@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S
 during kexec boot
References: <20120705210607.GA26908@aepfle.de>
 <20120706084120.GA31219@router-fw-old.local.net-space.pl>
 <20120706120750.GA8970@aepfle.de>
In-Reply-To: <20120706120750.GA8970@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.07.12 at 14:07, Olaf Hering <olaf@aepfle.de> wrote:
> But adding some debug to inspect
> *output in parse_elf() shows that the second entry in program headers is
> already shifted by 44 bytes in my testing, the others are shifted by the
> same amount.

Unfortunately it's not clear what is shifted - the printout below
looks just fine. Also, from your first mail I understood that the shift
there was by an amount not divisible by 4 - does that amount vary?

> Program Headers:
>   Type           Offset   VirtAddr           PhysAddr           FileSiz  
> MemSiz   Flg Align
>   LOAD           0x200000 0xffffffff81000000 0x0000000001000000 0xa3b000 
> 0xa3b000 R E 0x200000
>   LOAD           0xe00000 0xffffffff81c00000 0x0000000001c00000 0x05b0e8 
> 0x05b0e8 RW  0x200000
>   LOAD           0x1000000 0x0000000000000000 0x0000000001c5c000 0x012c40 
> 0x012c40 RW  0x200000
>   LOAD           0x106f000 0xffffffff81c6f000 0x0000000001c6f000 0x087000 
> 0x702000 RWE 0x200000
>   NOTE           0x82d5bc 0xffffffff8162d5bc 0x000000000162d5bc 0x00017c 
> 0x00017c     0x4
> 
> 
> That makes me wonder wether kexec-tools is the culprit.

Possibly, though generally any corruption to the compressed image
should make decompression fail I would think.

Jan

