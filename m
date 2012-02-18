Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2BRSYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 13:24:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55680 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab2BRSYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 13:24:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.153.15 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Sat, 18 Feb 2012 22:24:36 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: =?utf-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
        lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [BUG] task->nsproxy was unexpectedly NULL (caught in exit_shm)
Message-ID: <20120218182436.GB1905@moon>
References: <CAN8=baycwqAkTJxNpNzaO9G=TbEXeiEYCvWxiwvS+NpLRZi3xw@mail.gmail.com>
 <20120218173950.GA12595@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120218173950.GA12595@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 09:39:50PM +0400, Vasiliy Kulikov wrote:
...
> > 
> > So task->nsproxy was unexpectedly NULL atm.
> > The bug happened only once so far.
> 
> I'm confused.  How ->nsproxy can be NULL in do_exit()?  AFAIU, it is not a
> special process (i.e. init or udev), but a common chrome process.
> 
> Could it be missing get_nsproxy() somewhere?  And as a result, freed
> current->nsproxy while still having active users.
> 

Probably it would worth to repeat this issue without proprientary
drivers loaded. Also I wonder why don't we use rcu_assign_pointer
for nsproxy in copy_namespaces.

	Cyrill
