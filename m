Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0KGX2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:28:31 -0500
Received: from ozlabs.org ([203.10.76.45]:41868 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0KGX23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:28:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] Char: virtio_console, fix memory leak
Date: Mon, 8 Nov 2010 09:58:22 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
        Amit Shah <amit.shah@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz> <1289034412-24278-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1289034412-24278-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011080958.23163.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Nov 2010 07:36:50 pm Jiri Slaby wrote:
> Stanse found that in init_vqs, memory is leaked under certain
> circumstanses (the fail path order is incorrect). Fix that by checking
> allocations in one turn and free all of them at once if some fails
> (some may be NULL, but this is OK).

Good catch, thanks!

I generally prefer the static rather than lazy method of cleanup, but
in this case it's ugly both before and after...

Applied,
Rusty.
