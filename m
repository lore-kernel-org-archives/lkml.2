Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2HNOWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:22:21 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:24985 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2HNOWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:22:20 -0400
Message-ID: <502A5F14.4000007@parallels.com>
Date: Tue, 14 Aug 2012 18:22:12 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 3/8] procfs: Add ability to plug in auxiliary fdinfo providers
References: <20120814140342.354405844@openvz.org> <20120814140620.033884909@openvz.org>
In-Reply-To: <20120814140620.033884909@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 06:03 PM, Cyrill Gorcunov wrote:
> This patch brings ability to plug in auxiliary fdinfo providers.
> For example in further patches eventfd, evenpoll and fsnotify
> will print out information associated with files.
> 
> This feature is CONFIG_CHECKPOINT_RESTORE guarded to eliminate
> overhead for those who don't need it at all (this
> unfortunately makes patch bigger than I wanted).
> 
> The basic usage rule is the following
> 
>  - fdinfo provider should register own "show" method
>    via proc_register_fdinfo_driver call, where "show"
>    methods are rather well known seq-file operations
> 
>  - once the kernel opens /proc/$pid/fdinfo/$fd file
>    it calls for ->probe() method in registered fdinfo
>    drivers, and if probe success, then seq-file "show"
>    operations will be called to provide out additional
>    infomation
> 
> Initially we considered to inject some "show" metod to
> file_operations but since there really a number of
> file_operations declared inside kernel (and in real the
> further patches cover onle eventfd/epoll/inotify) the
> waste of memory space will be inacceptable I think.
> 
> Pavel, I've left seq_next memthod as it was simply because
> we can't leave seq_next() after calling extra->driver->ops->start
> without increasing "pos", thus we need to call for "show" manually
> once.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: James Bottomley <jbottomley@parallels.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

