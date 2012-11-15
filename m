Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab2KOXjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:39:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53531 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2KOXjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:39:13 -0500
Date: Thu, 15 Nov 2012 15:39:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Hozza <thozza@redhat.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com
Subject: Re: [PATCH] tools: hv: Netlink source address validation allows DoS
Message-ID: <20121115233909.GA17580@kroah.com>
References: <1352368409-18809-1-git-send-email-thozza@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352368409-18809-1-git-send-email-thozza@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 10:53:29AM +0100, Tomas Hozza wrote:
> The source code without this patch caused hypervkvpd to exit when it processed
> a spoofed Netlink packet which has been sent from an untrusted local user.
> Now Netlink messages with a non-zero nl_pid source address are ignored
> and a warning is printed into the syslog.
> 
> Signed-off-by: Tomas Hozza <thozza@redhat.com>
> Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 13c2a14..c1d9102 100755

Why are you setting a .c file to executable permissions?  Something is
really wrong here...

greg k-h
