Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0DTWwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 18:52:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414Ab0DTWwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 18:52:38 -0400
Date: Tue, 20 Apr 2010 15:51:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: linux-arm-kernel@lists.infradead.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Minchan Kim <minchan.kim@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: Suspicious compilation warning
Message-Id: <20100420155122.6f2c26eb.akpm@linux-foundation.org>
In-Reply-To: <k2ncecb6d8f1004191627w3cd36450xf797f746460abb09@mail.gmail.com>
References: <k2ncecb6d8f1004191627w3cd36450xf797f746460abb09@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Apr 2010 20:27:43 -0300
Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br> wrote:

> I get this warning while compiling for ARM/SA1100:
> 
> mm/sparse.c: In function '__section_nr':
> mm/sparse.c:135: warning: 'root' is used uninitialized in this function
> 
> With a small patch in fs/proc/meminfo.c, I find that NR_SECTION_ROOTS
> is zero, which certainly explains the warning.
> 
> # cat /proc/meminfo
> NR_SECTION_ROOTS=0
> NR_MEM_SECTIONS=32
> SECTIONS_PER_ROOT=512
> SECTIONS_SHIFT=5
> MAX_PHYSMEM_BITS=32

hm, who owns sparsemem nowadays? Nobody identifiable.

Does it make physical sense to have SECTIONS_PER_ROOT > NR_MEM_SECTIONS?
