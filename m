Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1ACMqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 07:46:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47986 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab1ACMqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 07:46:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=cGcvi6JUkoUWk4JCc7OZAg6JI/ZgloNYOgYAQ1UMvIi8iCsbl/SxEVSIdN+Kn0pJW8
         zl/IjGhKhJ/3/hHYmOY+q0KsyC+IvRCdIMvHzs/dYgCmbw6xxwX/5RGpRZfqr0QfVVzz
         XDaJcbOPldESJbQw7N98hhpjHiYctIukMFrWM=
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 13:46:42 +0100
Message-ID: <1294058802.19182.28.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure.  I can verify that the patch series (a) doesn't break well-behaved
> modules and (b) it *does* trigger for misbehaving modules (I sent the
> VirtualBox crew a bug report for a module that tried to write to an area
> marked executable).

This seems to be fixed by VirtualBox 4.

I applied the patchset to 2.6.36.
('All in one' patch, http://pastebin.com/raw.php?i=6CDnAkjP )

I have however noticed that after enabling;
CONFIG_DEBUG_KERNEL, CONFIG_DEBUG_RODATA and CONFIG_DEBUG_SET_MODULE_RONX
there are three "Freeing unused kernel memory" messages, is this correct?

Before applying patch:
[    1.449499] Freeing initrd memory: 16328k freed
[    3.336464] Freeing unused kernel memory: 844k freed

After applying patch:
[    1.449262] Freeing initrd memory: 16328k freed
[    3.297901] Freeing unused kernel memory: 844k freed
[    3.311849] Write protecting the kernel read-only data: 8192k
[    3.327592] Freeing unused kernel memory: 448k freed
[    3.342651] Freeing unused kernel memory: 276k freed

And why does CONFIG_DEBUG_RODATA depend on CONFIG_DEBUG_KERNEL;
Isn't it primarily a security enhancement?

-Tobias

