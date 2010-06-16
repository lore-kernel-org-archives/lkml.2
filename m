Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab0FPTLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 15:11:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50185 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab0FPTLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 15:11:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH] d_ino considered harmful
Date: Wed, 16 Jun 2010 21:10:42 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.35-rc1-00090-g358f4b6; KDE/4.4.2; x86_64; ; )
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20100616185913.GA15566@shell>
In-Reply-To: <20100616185913.GA15566@shell>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006162110.43322.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18cj6cS7dkz2x7WjVZHZgey9sbngFIPbfqleWi
 cXk7wpqgc1WoYvBMkvZgMAx1At1cF4CgrCy0PV1Rxb8YH+f+pt
 51fMyqcglsqbbjbIwzWCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 June 2010 20:59:13 Valerie Aurora wrote:
> @@ -91,7 +91,9 @@ static int fillonedir(void * __buf, const char * name, int namlen, loff_t offset
>  
>         if (buf->result)
>                 return -EINVAL;
> -       d_ino = ino;
> +       /* Use of d_ino without st_dev is always buggy. */
> +       d_ino = 0;
> +
>         if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
>                 buf->result = -EOVERFLOW;
>                 return -EOVERFLOW;

Isn't this just the path taken by sys_oldreaddir?

Glibc (at least on my box) translates all user calls to readdir into
sys_getdents or sys_getdents64, so I think you'd also need to change
filldir() and filldir64() for your testing.

	Arnd
