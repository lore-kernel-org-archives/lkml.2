Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab0I2T3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:29:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0I2T3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:29:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
Date: Wed, 29 Sep 2010 21:29:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
Cc: Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100929141112.26944.21931.stgit@build.ogc.int> <201009292117.54828.arnd@arndb.de> <ada4od82w5x.fsf@cisco.com>
In-Reply-To: <ada4od82w5x.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009292129.31415.arnd@arndb.de>
X-Provags-ID: V02:K0:Dby9X+JnLhx1G/zSu8umJOlJ8RUL+VqY21MOPnBp2NE
 JSAeUbiV/FdhR9aAHO1vb5mmPkR/o/R1j2Yt8xBaUhB1ik14pi
 pPVGpWhKRcwVA+6y1zoqujCFFMlIVPLZRtd0768Io0ojrHy0R1
 C7xMsbLgd/dvE6ZbCYaxvK/NljSUfygejqvD2hyPLAAZP71zjL
 mSjY+LDxIp9IKB5aj9Lgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 September 2010 21:21:14 Roland Dreier wrote:
> 
>  > The main difference between default_llseek and generic_file_llseek
>  > is that default_llseek doesn't care about the maximum file size
>  > of the underlying file system, which is ULONG_MAX on debugfs,
>  > so they are equivalent.
> 
> I thought default_llseek also takes the BKL still?

Not any more in linux-next.

>  > In general, the preferred one is no_llseek for those files where
>  > you know you do not need to seek. If you do, I'd use default_llseek
>  > for character devices and generic_file_llseek for file systems
>  > that set the s_maxbytes.
> 
> The case in question is for debugfs files, so we should use
> generic_file_llseek, right?

Yes, but it's a very weak "should". My automatic conversion script
uses default_llseek.

	Arnd
