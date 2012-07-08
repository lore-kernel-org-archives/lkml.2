Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab2GHWNu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:13:50 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55153 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752185Ab2GHWNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:13:49 -0400
Message-ID: <1341785628.13174.28.camel@joe2Laptop>
Subject: Re: [PATCH v2 05/11] fblog: register one fblog object per
 framebuffer
From: Joe Perches <joe@perches.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        florianschandinat@gmx.de, linux-fbdev@vger.kernel.org,
        gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk,
        bonbons@linux-vserver.org
Date: Sun, 08 Jul 2012 15:13:48 -0700
In-Reply-To: <1341784614-2797-6-git-send-email-dh.herrmann@googlemail.com>
References: <1341784614-2797-1-git-send-email-dh.herrmann@googlemail.com>
	 <1341784614-2797-6-git-send-email-dh.herrmann@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-08 at 23:56 +0200, David Herrmann wrote:
>

Hi David.  Trivial comments only:

> diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
[]
> @@ -23,15 +23,204 @@
>   * all fblog instances before running other graphics applications.
>   */

Please add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #include and...

>  static int __init fblog_init(void)
>  {
> +	int ret;
> +
> +	ret = fb_register_client(&fblog_notifier);
> +	if (ret) {
> +		pr_err("fblog: cannot register framebuffer notifier");

Missing newline, pr_fmt would add module name.

		pr_err("cannot register framebuffer notifier\n");



