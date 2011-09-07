Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab1IGWyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 18:54:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985Ab1IGWyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 18:54:45 -0400
Date: Wed, 7 Sep 2011 15:53:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nathan Lynch <ntl@pobox.com>, kernel-hardening@lists.openwall.com,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Glauber Costa <glommer@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [patch 2/2] fs, proc: Introduce the /proc/<pid>/map_files/
 directory v6
Message-Id: <20110907155332.beda7d3d.akpm@linux-foundation.org>
In-Reply-To: <20110907224234.GD28162@sun>
References: <20110905192009.GJ761@sun>
	<20110905194908.GA2690@albatros>
	<20110905203627.GL761@sun>
	<20110906101518.GA4799@albatros>
	<20110906165144.GJ18425@mtj.dyndns.org>
	<20110906172952.GA28055@albatros>
	<20110906173341.GM18425@mtj.dyndns.org>
	<20110907112301.GA12157@albatros>
	<20110907215329.GB28162@sun>
	<20110907151323.613e62e7.akpm@linux-foundation.org>
	<20110907224234.GD28162@sun>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 02:42:34 +0400
Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> > > +err:
> > > +		up_read(&mm->mmap_sem);
> > > +
> > > +		for (i = 0; i < used && !ret; i++) {
> > 
> > The "&& !ret" is unneeded?
> 
> No, it's needed, since it makes sure that if "impossible"
> scenario happens and flex-arrays fails with preallocated
> data so we will reach this point with used > 0 and ret = -ENOMEM
> and thus will not call for proc_map_files_instantiate as needed.

Well, it doesn't need to be tested on each pass around the loop - that's
misleading and inefficient (unless the compiler is being particularly clever).
