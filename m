Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab0JYVMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:12:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab0JYVMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:12:46 -0400
MIME-Version: 1.0
In-Reply-To: <20101025205746.GA6568@infradead.org>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
 <19653.55494.240658.165153@quad.stoffel.home> <4CC5DCBB.1070505@kernel.org>
 <AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com> <20101025205746.GA6568@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Oct 2010 14:11:45 -0700
Message-ID: <AANLkTi=0Yag66SwgqhudZ8atU6LjaXmTX62VmQ+JMmhF@mail.gmail.com>
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
To: Christoph Hellwig <hch@infradead.org>
Cc: "J.H." <warthog9@kernel.org>, John Stoffel <john@stoffel.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        zohar@us.ibm.com, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 1:57 PM, Christoph Hellwig <hch@infradead.org> wrote:
>
> Kyle sent a very useful patch to simply disable the ima tracking unless
> you enable it on the command line.

And exactly how does that invalidate _any_ of the patches in the IMA
series in question? All of them are basically still equally valid.

And the "four bytes in 'struct inode' is a total no-no" crowd clearly
haven't looked at struct inode. As mentioned, we've got things like
quota stuff there too.

And quite frankly, it sounds like the right thing to do for Fedora &co
is to simply _disable_ CONFIG_IMA. If there is no support for it on a
distro level, then you shouldn't enable it.

                           Linus
