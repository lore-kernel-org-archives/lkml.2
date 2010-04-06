Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab0DFFcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:32:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:42258 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab0DFFcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:32:10 -0400
Subject: Re: mprotect pgprot handling weirdness
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1270530566.13812.28.camel@pasglop>
References: <1270530566.13812.28.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 15:32:06 +1000
Message-ID: <1270531926.13812.29.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 15:09 +1000, Benjamin Herrenschmidt wrote:
> Hi folks !
> 
> While looking at untangling a bit some of the mess with vm_flags and
> pgprot (*), I notices a few things I can't quite explain... they may ..
> or may not be bugs, but I though it was worth mentioning:

 And another one:

- vma_wants_writenotify():

	/* The open routine did something to the protections already? */
	if (pgprot_val(vma->vm_page_prot) !=
	    pgprot_val(vm_get_page_prot(vm_flags)))
		return 0;

That's going to blow if any -other- prot bit is used here.

Cheers,
Ben.


