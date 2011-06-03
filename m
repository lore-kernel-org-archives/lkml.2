Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab1FCVcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:32:15 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:48601 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab1FCVcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:32:14 -0400
Date: Fri, 3 Jun 2011 17:32:06 -0400 (EDT)
From: Dave Anderson <anderson@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jstancek@redhat.com
Message-ID: <1972495451.7278.1307136726542.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110603204847.GM27166@one.firstfloor.org>
Subject: Re: [PATCH] x86-64: Prevent gcc from optimizing away venosys_1()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> >  	return 0;
> >  }
> >
> > -static long __vsyscall(3) venosys_1(void)
> > +long __vsyscall(3) venosys_1(void)
> 
> Better add a __used too. Otherwise it can be optimized out again
> in some builds e.g. when someone enables gc-sections for the linker.

Considering that all of the vsyscall prototypes have this attribute:

#define __vsyscall(nr) \
                __attribute__ ((unused, __section__(".vsyscall_" #nr))) notrace

How would any of them work?

Dave

> 
> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only.
