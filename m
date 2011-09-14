Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1INP16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:27:58 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48516 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784Ab1INP14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:27:56 -0400
Subject: Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Rosenberg <drosenberg@vsecurity.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@linux.intel.com>, Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20110914131630.GA7001@albatros>
References: <20110910164001.GA2342@albatros>
	 <20110910164134.GA2442@albatros>  <20110914131630.GA7001@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 08:18:25 -0700
Message-ID: <1316013505.4478.50.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-14 at 17:16 +0400, Vasiliy Kulikov wrote:
> > World readable slabinfo simplifies kernel developers' job of debugging
> > kernel bugs (e.g. memleaks), but I believe it does more harm than
> > benefits.  For most users 0444 slabinfo is an unreasonable attack vector.
> 
> Please tell if anybody has complains about the restriction - whether it
> forces someone besides kernel developers to do "chmod/chgrp".  But if
> someone want to debug the kernel, it shouldn't significantly influence
> on common users, especially it shouldn't create security issues. 

Ubuntu ships today with a /etc/init/mounted-proc.conf that does:

	chmod 0400 "${MOUNTPOINT}"/slabinfo

After cursing Kees's name a few times, I commented it out and it hasn't
bothered me again.  

I expect that the folks that really care about this (and their distros)
will probably have a similar mechanism.  I guess the sword cuts both
ways in this case: it obviously _works_ to have the distros do it, but
it was a one-time inconvenience for me to override that.

In other words, I dunno.  If we do this in the kernel, can we at least
do something like CONFIG_INSECURE to both track these kinds of things
and make it easy to get them out of a developer's way?

-- Dave

