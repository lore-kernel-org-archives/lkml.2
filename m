Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0CXJ0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:26:00 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:55937 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab0CXJZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:25:59 -0400
Subject: Re: Testing lxc 0.6.5 in Fedora 13
From: Greg Kurz <gkurz@fr.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Grzegorz Nosek <root@localdomain.pl>,
       containers@lists.linux-foundation.org, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100323212834.GH20796@count0.beaverton.ibm.com>
References: <20100321195044.GA23757@megiteam.pl>
	 <20100323212834.GH20796@count0.beaverton.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 10:25:56 +0100
Message-ID: <1269422756.24051.55.camel@bahia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 14:28 -0700, Matt Helsley wrote:
> On Sun, Mar 21, 2010 at 08:50:44PM +0100, Grzegorz Nosek wrote:
> 
> <snip>
> 
> > 2. Weird strace behaviour across pidns boundary
> > 
> > When strace'ing (with -ff) lxc-start, I get a proper strace for the
> > directly spawned process and the container init. However, any processes
> > spawned by the container's init are not straced properly (I get two
> > empty files, named <foo>.<pid-in-root-ns> and <foo>.2 -- presumably pid
> > inside the container). The container also seems to malfunction under
> > strace (looks like exec() failing as lxc-ps shows two "init" processes).
> > 

<snip>

> > 
> > 'strace ls' ran completely inside the container works as expected.
> 
> I'm suprised strace of ls works across pid namespaces. I've been looking

Matt,

Grzegorz is telling you that 'strace -ff lxc-start ls' is broken but
'lxc-start strace -ff ls' works as expected => strace of ls doesn't work
across pid namespaces. No surprise.

Cheers.

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

