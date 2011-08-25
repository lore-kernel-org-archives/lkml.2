Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1HYVMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 17:12:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43786 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab1HYVMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 17:12:18 -0400
Date: Thu, 25 Aug 2011 23:12:13 +0200
From: Tejun Heo <tj@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>, containers@lists.osdl.org,
        Zan Lynx <zlynx@acm.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110825211213.GP2803@mtj.dyndns.org>
References: <20110824085329.GL29452@sun>
 <20110824111806.GA7191@albatros>
 <20110825082944.GH10030@sun>
 <20110825170147.GM2803@mtj.dyndns.org>
 <20110825170705.GA6387@sun>
 <20110825205426.GO2803@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825205426.GO2803@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, Aug 25, 2011 at 10:54:26PM +0200, Tejun Heo wrote:
> Another thing is, I don't really see why we need vm_start, or fd for
> that matter, in proc_inode at all.  proc_inode is created on the fly
> only as dentry gets instantiated on demand, which means we always have
> d_name on hand to tell what the file is supposed to point to.  In
> fact, the code already uses name_to_int() to extract fd from d_name.
> Hmmm... well yeah, it actually seems that proc_inode->fd is never used
> and we can simply remove it.

Unfortunately, not quite as easy as I expected.  The information still
seems redundant but it seems we'll need to change
proc_inode->get_link() to take dentry instead of inode before doing
away with proc_inode->fd, but, at any rate, I don't think this is a
big deal one way or the other.

Thanks.

-- 
tejun
