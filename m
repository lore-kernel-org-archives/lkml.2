Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab1IALuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:50:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37382 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1IALuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:50:14 -0400
Date: Thu, 1 Sep 2011 20:50:06 +0900
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Vasiliy Kulikov <segoon@openwall.com>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
Message-ID: <20110901115006.GB2752@htj.dyndns.org>
References: <20110831075814.003575573@openvz.org>
 <20110831080229.100652529@openvz.org>
 <20110831090612.GA3253@albatros>
 <20110831112642.GI25465@sun>
 <20110831140416.GA17626@shutemov.name>
 <20110831142622.GB30615@sun>
 <20110831151023.5b7e12da.akpm@linux-foundation.org>
 <4E5F3B25.9030701@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5F3B25.9030701@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew, Pavel.

On Thu, Sep 01, 2011 at 11:58:29AM +0400, Pavel Emelyanov wrote:
> > What additional kernel patches are required to bring that effort to a
> > usable state and where are those patches?
> 
> * The one you've already accepted with ->statfs for pipefs.
> * PTRACE_SEIZE set from Tejun (RFC was sent some time earlier)

This one is already in mainline.  It's necessary to make the existing
debuggers (strace and gdb) interact properly with job control.

> * CLONE_USEPID flag for the clone() syscall (Cyrill will re-send a bit later)
> * The binfmt handler for images (I've sent it earlier, but there's a discussion
>   happening over it. We can do restore without one, but it will improve the
>   situation significantly)

I still can't see much point in binfmt handler.  The kernel pieces
should be pretty small no matter how this one gets resolved.

Thanks.

-- 
tejun
