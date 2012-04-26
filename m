Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2DZPCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:02:09 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60836 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab2DZPCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:02:08 -0400
Date: Thu, 26 Apr 2012 08:01:59 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org
Subject: Re: [BUG]memblock: fix overflow of array index
Message-ID: <20120426150159.GA27486@google.com>
References: <CAHnt0GXW-pyOUuBLB1n6qBP4WNGpET9er_HbJ29s5j5DE1xAdA@mail.gmail.com>
 <20120425222819.GF8989@google.com>
 <CAHnt0GWABX8qOVTinmSETUHxq1Y3NhqPOKxnUgcDtyf8wjtg_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHnt0GWABX8qOVTinmSETUHxq1Y3NhqPOKxnUgcDtyf8wjtg_g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 26, 2012 at 08:50:58AM +0800, Peter Teoh wrote:
> Thanks for the reply.   Just an educational question:  is it possible
> to set one-byte per memblock?    And what is the minimum memblock
> size?

1 byte.

> Even if 2G memblock is a huge number, it still seemed like a bug to me
> that there is no check on the maximum number (which is 2G) of this
> variable (assuming signed int).   Software can always purposely push
> that number up and the system can panic?

Yeah, if somebody messes the BIOS / firmware to oblivion.  I don't
really care at that point tho.  memblock is a boot time memory
allocator and it assumes BIOS / firmware isn't completely crazy.  It
uses contiguous tables to describe all the blocks, walks them
one-by-one for allocation and even compacts them.

Well before memblock fails from any of the above, the machine would be
failing miserably in firmware / BIOS.

Thanks.

-- 
tejun
