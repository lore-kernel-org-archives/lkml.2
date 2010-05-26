Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773Ab0EZIoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:44:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:43135 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab0EZIom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:44:42 -0400
Subject: Re: [PATCH 2/8] PM: suspend_block: Add driver to access suspend
 blockers from user-space
From: Peter Zijlstra <peterz@infradead.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Jim Collar <jim.collar@eqware.net>, Greg Kroah-Hartman <gregkh@suse.de>,
       Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Magnus Damm <damm@igel.co.jp>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Nigel Cunningham <nigel@tuxonice.net>, linux-doc@vger.kernel.org
In-Reply-To: <1274482015-30899-3-git-send-email-arve@android.com>
References: <1274482015-30899-1-git-send-email-arve@android.com>
	 <1274482015-30899-2-git-send-email-arve@android.com>
	 <1274482015-30899-3-git-send-email-arve@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 10:43:48 +0200
Message-ID: <1274863428.5882.4860.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 15:46 -0700, Arve Hjønnevåg wrote:
> +To create a suspend blocker from user space, open the suspend_blocker
> special
> +device file:
> +
> +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> +
> +then optionally call:
> +
> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_SET_NAME(strlen(name)), name);
> +
> +To activate the suspend blocker call:
> +
> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_BLOCK);
> +
> +To deactivate it call:
> +
> +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_UNBLOCK);
> +
> +To destroy the suspend blocker, close the device:
> +
> +    close(fd);

Urgh, please let the open() be BLOCK, the close() be UNBLOCK, and keep
the SET_NAME thing if you really care.

