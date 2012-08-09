Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2HIDKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 23:10:37 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:45387 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2HIDKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 23:10:35 -0400
Date: Wed, 8 Aug 2012 20:09:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] proc: add /proc/pid/shmaps
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE37A530@SHSMSX102.ccr.corp.intel.com>
Message-ID: <alpine.LSU.2.00.1208081950080.1306@eggly.anvils>
References: <1344431059-12514-1-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.00.1208081409300.7178@chino.kir.corp.google.com> <9E0BE1322F2F2246BD820DA9FC397ADE37A530@SHSMSX102.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012, Ren, Qiaowei wrote:
> On Wed, 8 Aug 2012, David Rientjes wrote: 
> > On Wed, 8 Aug 2012, Qiaowei Ren wrote:
> >
> > > Add a shmaps entry to /proc/pid: show information about shared memory in an address space.
> > > 
> > > People that use shared memory and want to perform an analyzing about it. For example, judge whether any memory address is shared. This file just contains 'share' part of /proc/pid/maps now. There are too many contents in maps, and so we have to do a lot of analysis to obtain relative information every time.
> > > 
> > > Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> >  
> > Nack as unnecessary; /proc/pid/maps already explicitly emits 's' for VM_MAYSHARE and 'p' otherwise so this information is already available to userspace.
> >
> 
> Thanks for your reply. There are so many contents in /proc/pid/maps, and usually only a very small minority of those are about shared memory in address space of every process. So I hope that a new file maybe provide some convenience. Could you tell me how to get such information except analyzing 'maps' file?

You are joking?  Please imagine what the kernel and /proc would look like
if it provided a personally tailored /proc file to everybody who could not
be bothered to parse the information already shown there.

Sure, there is already lots of ugly and duplicative junk under /proc,
which usually has to be kept to preserve back compatibility; but please
do not try to add to it.

There is sometimes an excuse if some fields of an existing /proc file are
significantly more expensive for the kernel to compute than others: then
a file which separates them can save processing.  But that is definitely
not the case here.

A side issue would be whether parsing /proc/pid/maps for 's' VM_MAYSHARE
mappings (or your equivalent patch) actually tells you what you want to
know about "shared memory" - that would depend on what you really want
to know, and what you mean by shared memory.

Hugh
