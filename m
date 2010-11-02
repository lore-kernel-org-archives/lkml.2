Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0KBQWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:22:49 -0400
Received: from mx2.netapp.com ([216.240.18.37]:42187 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab0KBQWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:22:43 -0400
X-IronPort-AV: E=Sophos;i="4.58,283,1286175600"; 
   d="scan'208";a="476551142"
Subject: Re: [PATCH v2] Regression: fix mounting NFS when NFSv3 support is
 not compiled
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101031162105.23213.60220.stgit@localhost.localdomain>
References: <20101031162105.23213.60220.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Tue, 02 Nov 2010 12:21:28 -0400
Message-ID: <1288714888.2925.63.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 02 Nov 2010 16:22:24.0910 (UTC) FILETIME=[22533AE0:01CB7AAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-31 at 18:21 +0200, Paulius Zaleckas wrote:
> Trying to mount NFS (root partition in my case) fails if CONFIG_NFS_V3
> is not selected. nfs_validate_mount_data() returns EPROTONOSUPPORT,
> because of this check:
> 
> #ifndef CONFIG_NFS_V3
> 	if (args->version == 3)
> 		goto out_v3_not_compiled;
> #endif /* !CONFIG_NFS_V3 */
> 
> and args->version was always initialized to 3.
> 
> It was working in 2.6.36
> 
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>

This one looks good. Applied...

Trond
