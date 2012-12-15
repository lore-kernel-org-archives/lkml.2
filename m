Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2LORxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 12:53:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40448 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab2LORxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 12:53:51 -0500
Date: Sat, 15 Dec 2012 18:53:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Denis Kirjanov <kirjanov@gmail.com>,
        linux-edac <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 12/12] edac: fix kernel panic on module unloading
Message-ID: <20121215175347.GA19728@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-kernel@vger.kernel.org, Denis Kirjanov <kirjanov@gmail.com>,
	linux-edac <linux-edac@vger.kernel.org>
References: <20121214110229.11019.63713.stgit@zurg>
 <20121214110310.11019.21098.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121214110310.11019.21098.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 03:03:10PM +0400, Konstantin Khlebnikov wrote:
> This patch fixes use-after-free and double-free bugs in
> edac_mc_sysfs_exit(). mci_pdev has single reference and put_device()
> calls mc_attr_release() which calls kfree(), thus following
> device_del() works with already released memory. An another kfree() in
> edac_mc_sysfs_exit() releses the same memory again. Great.

Applied and tagged for 3.6 and 3.7 stable.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
