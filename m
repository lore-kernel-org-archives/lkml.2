Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1HYVji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 17:39:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46301 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab1HYVjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 17:39:36 -0400
Date: Thu, 25 Aug 2011 23:39:31 +0200
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
Message-ID: <20110825213931.GR2803@mtj.dyndns.org>
References: <20110824085329.GL29452@sun>
 <20110824111806.GA7191@albatros>
 <20110825082944.GH10030@sun>
 <20110825170147.GM2803@mtj.dyndns.org>
 <20110825170705.GA6387@sun>
 <20110825205426.GO2803@mtj.dyndns.org>
 <20110825211213.GP2803@mtj.dyndns.org>
 <20110825213459.GA1929@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825213459.GA1929@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 26, 2011 at 01:34:59AM +0400, Cyrill Gorcunov wrote:
> > Unfortunately, not quite as easy as I expected.  The information still
> > seems redundant but it seems we'll need to change
> > proc_inode->get_link() to take dentry instead of inode before doing
> > away with proc_inode->fd, but, at any rate, I don't think this is a
> > big deal one way or the other.
> 
> Hohum... picking up an additional reference to dentry might be dangerous
> I think. How exactly you imagine we would do that? (without this problem
> I guess we indeed may drop or rather not change proc-inode).

Why would you need an extra reference?  All these data structures are
created dynamically on access and dentry is always available while any
operation on the inode is in progress so it's guaranteed to be
available and there's no reason to diddle with reference count.
Anyways, we can deal with this optimization later, I think.

Thanks.

-- 
tejun
