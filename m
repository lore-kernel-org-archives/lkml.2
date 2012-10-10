Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2JJMhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:37:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab2JJMhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:37:22 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Constantine Shulyupin <const@makelinux.com>
Cc: nsekhar@ti.com, gregkh@linuxfoundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] USB: usb-skeleton.c: fix compilation error and restore kref_put on fail in skel_open
Date: Wed, 10 Oct 2012 14:35:36 +0200
Message-ID: <1952553.sIPjpLauNn@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc4-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <1349865174-21649-1-git-send-email-const@MakeLinux.com>
References: <1349865174-21649-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 October 2012 12:32:54 Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> Function skel_open increments usage count for the device with kref_get and the usage count should be decremented on the function failure.
> 
> Some last changes in function skel_open and finally commit
> 52a7499 Revert "USB: usb-skeleton.c: fix open/disconnect race"
> introduced a bug in function skel_open, which this patch fixes.
> 
> --
> Changelog:
> -- Fixed accordinly feedback of Oliver Neukum oneukum@suse.de: also need to drop the lock.

Well, touching file->private_data is not nice. It is correct, but
really dirty. The skeleton driver should be nice. Could you introduce
a second label for goto at the right place?

	Regards
		Oliver

