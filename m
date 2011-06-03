Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1FCUsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:48:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46150 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab1FCUsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:48:50 -0400
Date: Fri, 3 Jun 2011 22:48:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Anderson <anderson@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
        jstancek@redhat.com
Subject: Re: [PATCH] x86-64: Prevent gcc from optimizing away venosys_1()
Message-ID: <20110603204847.GM27166@one.firstfloor.org>
References: <313387488.1201.1307114323524.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com> <2060873692.1232.1307114423575.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2060873692.1232.1307114423575.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	return 0;
>  }
>  
> -static long __vsyscall(3) venosys_1(void)
> +long __vsyscall(3) venosys_1(void)

Better add a __used too. Otherwise it can be optimized out again
in some builds e.g. when someone enables gc-sections for the linker.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
