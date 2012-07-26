Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2GZKnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:43:22 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:43510 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab2GZKnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:43:20 -0400
Message-ID: <50111F36.6000407@parallels.com>
Date: Thu, 26 Jul 2012 14:43:02 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 2/7] procfs: Convert /proc/pid/fdinfo/ handling routines
 to seq-file
References: <20120725094718.089879534@openvz.org> <20120725095024.760705388@openvz.org>
In-Reply-To: <20120725095024.760705388@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 01:47 PM, Cyrill Gorcunov wrote:
> This patch converts /proc/pid/fdinfo/ handling routines to seq-file which
> is needed to extend seq operations and plug in auxiliary fdinfo provides
> from subsystems like eventfd/eventpoll/fsnotify.
> 
> Note the proc_fd_link no longer call for proc_fd_info, simply because
> proc_fd_info is converted to seq_fdinfo_open (which is seq-file open()
> prototype), moreover in further patches I need to provide two seq_fdinfo_open
> variants -- one with CONFIG_CHECKPOINT_RESTORE and one without this
> symbol. All in one -- this will look more messy then.

This is something I'm really not happy with :( After the set applied we will
have one former proc_fd_info being splitted into 3 (three!) functions doing
the same (with flavors).

For me it's better to fix this, otherwise conversion to seq-file looks OK.

> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: James Bottomley <jbottomley@parallels.com>
> ---
>  fs/proc/fd.c |  133 +++++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 85 insertions(+), 48 deletions(-)
