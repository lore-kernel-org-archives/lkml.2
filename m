Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0DFN6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:58:52 -0400
Received: from exhub016-4.exch016.msoutlookonline.net ([207.5.72.225]:10110
	"EHLO EXHUB016-4.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab0DFN6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:58:45 -0400
Message-ID: <4BBB3E0F.1030309@cfl.rr.com>
Date: Tue, 6 Apr 2010 09:58:39 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Extended partition mapping wrong size
References: <4BB0D12B.6060701@cfl.rr.com> <20100406114706.GA30340@nb.net.home>
In-Reply-To: <20100406114706.GA30340@nb.net.home>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/2010 7:47 AM, Karel Zak wrote:
> This is probably kernel bug. It's really insane that the extended
> pseudo partition overflows to the next logical partition.

Indeed.

>  Please no. I think the size should not be more than 2 sectors (1024
>  bytes). The current concept works for years and we have in userspace 
>  /etc/partitions parsers that use "if (blocks <= 1)" to detect
>  extended partitions.

Could you elaborate a bit on this?  What programs have such tests and
what would they do differently if it were larger?

>  The other problem are mkfs programs, the space used for alignment
>  could be 1MiB (or more) -- it's enough many mkfs programs.

What's wrong with that?  If you REALLY want to, there's no reason you
can't create a tiny fs there.  Then again, I could swear that once upon
a time the kernel simply did not bother creating a dev node for the
extended partition, and this seems to be a hack that was put in to make
it easy for LILO to install to one.  Personally I'd prefer going back to
the old behavior of just not having a useless device there.

>  BTW, Linux does not use this policy for the others nested partition
>  tables (e.g. Solaris, BSD, Minix, ...). The extended dos partition
>  table is exception. The primary partitions for the others nested PT
>  are exported to the system with its real size :-)

Indeed, also the hidden space in the logical partitions is also not
exposed, otherwise you would have two dev nodes per logical partition.
