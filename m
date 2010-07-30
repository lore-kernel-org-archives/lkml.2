Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab0G3DlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 23:41:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53187 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab0G3DlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 23:41:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 30 Jul 2010 12:36:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Message-Id: <20100730123620.ab49df4f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201007300129.33912.rjw@sisk.pl>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<201007300129.33912.rjw@sisk.pl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jul 2010 01:29:33 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
 
> Well, the rule of thumb (if it can be called this way) is that the contents of
> the image has to be consistent with whatever is stored in permanent storage.
> So, for example, filesystems that were mounted before creating the image
> cannot be modified until the image is restored.  Consequently, if there are
> any kernel threads that might cause that to happen, they need to be frozen.
> 
> Now, if I understand it correctly, the failure mode is that certain page had
> been swapped out before the image was created and then it was swapped in
> while we were writing the image out and the slot occupied by it was re-used.
> In that case the image would contain wrong information on the state of the
> swap and that would result in wrong data being loaded into memory on an attempt
> to swap that page in after resume.
> 
> So, generally, we have to avoid doing things that would result in swapping
> memory pages out after we have created a hibernation image.  If that can be
> achieved by freezing certain kernel threads, that probably is the simplest
> approach.
> 

BTW, I can't understand what happens in following situation. 

1. start saving image.
2. at saving image, swap entry is used and swap_map[off] += 1.
3. At some point, swap_map[] itself is saved.
...

At restore, IIUC, hibernation don't call any swap_free().
Where does the +1 goes ?
I'm sorry if I misunderstand.

Thanks,
-Kame


