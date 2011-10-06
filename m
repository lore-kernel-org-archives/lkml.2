Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab1JFTF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 15:05:59 -0400
Received: from quechua.inka.de ([193.197.184.2]:44525 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab1JFTF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 15:05:58 -0400
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 15:05:57 EDT
Date: Thu, 06 Oct 2011 20:44:57 +0200
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] [SIGNED-OFF] ext4: don't work without procfs
References: <1317916276-2509-1-git-send-email-yargil@free.fr> <1317916878.1823.2.camel@Joe-Laptop>
Organization: private Linux site, southern Germany
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: Olaf Titz <olaf@bigred.inka.de>
Message-ID: <E1RBswD-0003hi-Eo@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would make more sense as:
>
> +#ifdef CONFIG_PROC_FS
> 	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
>   	if (!ext4_proc_root)
>  		goto out5;
> +#endif

Looks right, but even more logical would be to guard _all_ usage of
ext4_proc_root (and, consequently, the declaration thereof) in #ifdef
CONFIG_PROC_FS. Now it's at least necessary to always do null checks.

Olaf
