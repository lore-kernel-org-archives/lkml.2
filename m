Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0F3Jbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:31:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab0F3Jbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:31:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 11:31:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
References: <201006301030.52235.arnd@arndb.de> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk> <25470.1277888151@redhat.com>
In-Reply-To: <25470.1277888151@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301131.37241.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX182S5jEutiKJdMvxFE2GSc9ZMpFz8FNO6A863r
 MbUFvcUwrllv/ns3ujo04kcrVfVDNT7Lcjl1NVqbq/qqLnOPm4
 zpnp4Lj7EFeN+23J4OYjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010 10:55:51 David Howells wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > I think it would be better to leave the structure as write-only from
> > the kernel
> 
> Why?

Consistency mostly. stat and stat64 don't read it, so I think xstat
also shouldn't if we can easily avoid it.

It also makes things like strace more complicated.

> > and pass the query_flags and struct_version as syscall arguments, though it
> > makes sense to store them in the result as well.
> 
> The problem with that is that the number of syscall arguments is limited, and
> there is no SYSCALL_DEFINE7.
> 
> On the other hand, I could make a separate argument block struct and pass a
> pointer to it...

No, I think that would be worse than the current version. But if you remove
the structure version in favor of the flags, you only need six arguments
anyway.

You can also go further and fold the structure length into flags, because
the length is just a function of the data you are passing.

Having a system call with flags, size and version is like wearing a belt,
braces and suspenders. An unsigned long flags argument should be enough to
hold up your pants[1].

	Arnd

[1] I hope I managed to make this sound wrong in both American and proper
English.
