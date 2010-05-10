Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0EJGay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:30:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42970 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab0EJGaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:30:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 10 May 2010 15:26:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
       containers@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Phil Carmody <ext-phil.2.carmody@nokia.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cgroups: make cftype.unregister_event()
 void-returning
Message-Id: <20100510152644.3ff6e0a5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100510150815.3d2f7647.kamezawa.hiroyu@jp.fujitsu.com>
References: <1273363822-7796-1-git-send-email-kirill@shutemov.name>
	<20100510150815.3d2f7647.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 15:08:15 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Sun,  9 May 2010 03:10:22 +0300
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > Since we unable to handle error returned by cftype.unregister_event()
> > properly, let's make the callback void-returning.
> > 
> > mem_cgroup_unregister_event() has been rewritten to be "never fail"
> > function. On mem_cgroup_usage_register_event() we save old buffer
> > for thresholds array and reuse it in mem_cgroup_usage_unregister_event()
> > to avoid allocation.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> 
> Hmm, just reusing buffer isn't enough ?
> as
> 	tmp = memory->thresholds;
> 	reduce entries on tmp
> And what happens when
> 
> 	register
> 	register
> 	register	
> 	unregister  (use preallocated buffer)
> 	unregister  ????
> 	unregister
> 
Ah, sorry my eyes were wrong.

The fix seems to work. 

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

