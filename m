Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab0F3Nbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:31:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0F3Nbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:31:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Wed, 30 Jun 2010 15:31:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: David Howells <dhowells@redhat.com>, Andreas Dilger <adilger@dilger.ca>,
       viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
References: <52423201-3DF9-4045-8E8B-FAA915053D56@dilger.ca> <26505.1277899544@redhat.com> <20100630121127.GA22713@infradead.org>
In-Reply-To: <20100630121127.GA22713@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301531.39365.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+C8pEFvNlGgTnatwa61kUlJ+bbKOYF2VQq4Cz
 KELevEKkGboW3Ydo8GinqZYGVBbKV9roqT87Wq2X2x+dE+guYm
 mQ634En9gUmZ5ZwwQEeyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010, Christoph Hellwig wrote:
> The cost of adding a syscall is much smaller

Ack. No need for different struct layout version since we
can add another stat syscall every ten years.

> So adding a few fields of padding at the end for new members is fine,
> but doing overkill of versioning including queries for supported
> versions doesn't.

The ability to request and return a subset of the fields seems useful
regardless and it can be used to avoid the need for this kind of padding.
A sufficient amount of padding wouldn't be too bad either, but I guess
we should not have both the padding _and_ the option for extending the
structure after the padding.

With the padding, the 'size' argument can go away, though I'd argue that
even without the padding we can safely add extra fixed-length fields
when needed and not need a size argument.

	Arnd
