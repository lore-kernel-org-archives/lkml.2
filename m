Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496Ab0LNO7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 09:59:16 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59746 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab0LNO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 09:59:15 -0500
Date: Tue, 14 Dec 2010 20:29:20 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [Patch 0/21] Non disruptive application core dump
 infrastructure
Message-ID: <20101214202920.6835a3c2@suzukikp>
In-Reply-To: <20101214105405.GB4834@core2.telecom.by>
References: <20101214152259.67896960@suzukikp>
	<20101214105405.GB4834@core2.telecom.by>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 12:54:05 +0200
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Tue, Dec 14, 2010 at 03:22:59PM +0530, Suzuki K. Poulose wrote:
> > The interface is provided by a /proc/pid/core file, reading which can give the 
> 
> What happens when process opens /proc/self/core ?
The current thread will be skipped for freeze(), and all the others will be 
frozen.We fill in the register states with 0's for the active threads.

> What happens when process opens /proc/self/core and coredumps before close(2).

Thanks for pointing this out. With the current code, this causes a hang for the
 current process, waiting for the other threads to clear. I will think about 
a solution to this making use of the mm->core_state information.


Thanks a lot for the review.

Suzuki
