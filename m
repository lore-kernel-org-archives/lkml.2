Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0F3IVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:21:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab0F3IVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:21:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available
Date: Wed, 30 Jun 2010 10:20:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
References: <20100629200259.23196.81509.stgit@warthog.procyon.org.uk> <20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301020.53978.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX193kl+pnTFOIqPxusHU/lx/zhZbhXDpUJFytWt
 SSkLz17DttmhTjG+11NybaE38ctKrJ7br4oJ1xbRGGrkQTZjFy
 GZCnWlZa91RhuFV+XTHTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 June 2010 22:03:15 David Howells wrote:
>         ssize_t ret = xstat(int dfd,
>                             const char *filename,
>                             unsigned atflag,
>                             struct xstat *buffer,
>                             size_t buflen);
> 
>         ssize_t ret = fxstat(int fd,
>                              struct xstat *buffer,
>                              size_t buflen);
> 
> 
> The dfd, filename, atflag and fd parameters indicate the file to query.  There
> is no equivalent of lstat() as that can be emulated with xstat(), passing 0
> instead of AT_SYMLINK_NOFOLLOW as atflag.

Do we actually need the fxstat variant? IIRC, some *at syscalls just
operate on dfd when filename==NULL, which would be trivial to do here.

	Arnd
