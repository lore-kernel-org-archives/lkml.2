Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2IFWpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:45:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2IFWpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:45:00 -0400
Date: Thu, 6 Sep 2012 15:44:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 12/15] firmware: introduce
 device_cache/uncache_fw_images
Message-Id: <20120906154459.8b3b73fa.akpm@linux-foundation.org>
In-Reply-To: <1344052890-31935-13-git-send-email-ming.lei@canonical.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
	<1344052890-31935-13-git-send-email-ming.lei@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  4 Aug 2012 12:01:27 +0800
Ming Lei <ming.lei@canonical.com> wrote:

> This patch introduces the three helpers below:
> 
> 	void device_cache_fw_images(void)
> 	void device_uncache_fw_images(void)
> 	void device_uncache_fw_images_delay(unsigned long)

CONFIG_PM=n:

drivers/base/firmware_class.c:1147: warning: 'device_cache_fw_images' defined but not used
drivers/base/firmware_class.c:1212: warning: 'device_uncache_fw_images_delay' defined but not used

the fix is not trivial - this patch added quite a lot of code and data
structure bloat which will never be used on CONFIG_PM=n kernels.


(Well, a trivial fix would be to eradicate CONFIG_PM=n, but...)
