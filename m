Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab2GDHjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:39:42 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31818 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab2GDHjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:39:40 -0400
Message-ID: <4FF3F332.5030302@parallels.com>
Date: Wed, 04 Jul 2012 11:39:30 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [rfc 3/7] procfs: Add ability to plugin auxiliary fdinfo providers
References: <20120627110116.201735815@openvz.org> <20120627110512.574379921@openvz.org>
In-Reply-To: <20120627110512.574379921@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2012 03:01 PM, Cyrill Gorcunov wrote:
> This patch brings ability to plugin auxiliary fdinfo providers.
> For example in further patches eventfd, evenpoll and fsnotify
> will print out information associated with files.
> 
> This feature is CONFIG_CHECKPOINT_RESTORE guarded to eliminate
> overhead for those who don't need it at all (this
> unfortunately makes patch bigger than I wanted).
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: James Bottomley <jbottomley@parallels.com>
> ---
>  fs/proc/fd.c            |  208 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/proc_fs.h |   28 ++++++
>  2 files changed, 236 insertions(+)

How about introducing one more file_operations member and call it in the
seq_show() (if exists)? Only inotify, eventfd and eventpoll will implement
one. This will allow to avoid all this complexity with drivers.
