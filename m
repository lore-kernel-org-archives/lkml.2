Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab0F3Mog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 08:44:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0F3Moe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 08:44:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 14:44:10 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
References: <201006301346.41902.arnd@arndb.de> <29346.1277892068@redhat.com> <26650.1277900050@redhat.com>
In-Reply-To: <26650.1277900050@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301444.11194.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19NlZNiiN1s/Q/2w06bGUmn0oAJ7uu/8g7ZkXe
 StbMQUQRD5+Xi89eXMw4sOG+99GzO0mYxO0mVMSq7NI7NxONPF
 Ufr6ln2HvFsrSETFzsLPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010, David Howells wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > Given a 64 bit flag word, you can start using bits for the version from
> > the top and bits from the bottom for fields:
> 
> I suppose.  It's cleaner, though, to keep them separate.

Yes, but it's a tradeoff. If separating them means you have to add
another structure, I'd prefer having just a flags word with different
kinds of bits. In particular since I don't think we actually need
to worry about wildly different layouts. If struct oldstat had
come with an extensibility concept like what you propose here, we
would not have needed newstat, stat64 and xstat.

> > Alternatively, you can also make it a 64 bit argument everywhere, which has
> > some other small disadvantages.
> 
> No, you can't.  32-bit systems can only pass 32-bit arguments.  If you're
> suggesting passing a pointer to a 64-bit argument instead, how's that any
> different from my suggestion of a separate parameter block?

I was thinking of splitting the 64 bit argument into two registers on
32 bit systems, like we do with other 64 bit input arguments (e.g. loff_t).
While there is not much of a difference, I'd always prefer passing
input arguments by register to a memory location when possible.

> > The idea of a syscall API with multiple fixed-length and variable-length
> > fields in the same structure scares me. If you want to go this far,
> > it may be better to base the interface on netlink and allow querying
> > multiple files at once.
> 
> Urgh.  Netlink is way too much overhead and even scarier.  That's pretty much
> a guarantee that people won't use it.  It also has to work if CONFIG_NET=n.

Exactly. Just resist the urge to add complexity bordering what we already
have in netlink.

	Arnd
