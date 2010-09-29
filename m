Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab0I2TSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:18:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab0I2TSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:18:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
Date: Wed, 29 Sep 2010 21:17:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
Cc: Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100929141112.26944.21931.stgit@build.ogc.int> <adawrq431sr.fsf@cisco.com>
In-Reply-To: <adawrq431sr.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009292117.54828.arnd@arndb.de>
X-Provags-ID: V02:K0:UqHGOPAdJlgqrHsuUVjRAFJFb7+1vCiCfvNL1A0GLyl
 B30C6pIDld8dOW9p5Mfyd1LdR29NtF23iXWJ+uc9XZzV7X32UF
 rnpIEccTEu9fa6PEdH6+tI8/pWunz/texYGomm3hzw36qJi5xV
 soY834iuBl0vRGlYtakqfJe+VUGVhI0ocPwhUjc+ohd+0hfyPG
 Z4qzsGUX2TO4j1BK5K+rg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 September 2010 19:19:32 Roland Dreier wrote:
>  > @@ -182,6 +182,7 @@ static const struct file_operations qp_debugfs_fops = {
>  >      .open    = qp_open,
>  >      .release = qp_release,
>  >      .read    = debugfs_read,
>  > +    .llseek  = default_llseek,
>  >  };
> 
> I think this could actually be generic_file_llseek (right, Arnd?).

The main difference between default_llseek and generic_file_llseek
is that default_llseek doesn't care about the maximum file size
of the underlying file system, which is ULONG_MAX on debugfs,
so they are equivalent.

In general, the preferred one is no_llseek for those files where
you know you do not need to seek. If you do, I'd use default_llseek
for character devices and generic_file_llseek for file systems
that set the s_maxbytes.

	Arnd
