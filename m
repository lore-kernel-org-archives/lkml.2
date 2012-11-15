Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767930Ab2KONvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:51:21 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:16311 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767793Ab2KONvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:51:18 -0500
Message-ID: <50A4F340.9080201@parallels.com>
Date: Thu, 15 Nov 2012 17:50:56 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 7/7] fs, notify: Add procfs fdinfo helper v6
References: <20121114151937.344922058@openvz.org> <20121114152239.936025193@openvz.org>
In-Reply-To: <20121114152239.936025193@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This allow us to print out fsnotify details such as
> watchee inode, device, mask and optionally a file handle.
> 
> For inotify objects if kernel compiled with exportfs support
> the output will be
> 
>  | pos:	0
>  | flags:	02000000
>  | inotify wd:        3 ino:             9e7e sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 7e9e0000640d1b6d
>  | inotify wd:        2 ino:             a111 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 11a1000020542153
>  | inotify wd:        1 ino:            6b149 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 49b1060023552153
> 
> If kernel compiled without exportfs support, the file handle
> won't be provided but inode and device only.
> 
>  | pos:	0
>  | flags:	02000000
>  | inotify wd:        3 ino:             9e7e sdev:   800013 mask:  800afce ignored_mask:        0
>  | inotify wd:        2 ino:             a111 sdev:   800013 mask:  800afce ignored_mask:        0
>  | inotify wd:        1 ino:            6b149 sdev:   800013 mask:  800afce ignored_mask:        0
> 
> For fanotify the output is like
> 
>  | pos:	0
>  | flags:	02
>  | fanotify ino:            68f71 sdev:   800013 mask:        1 ignored_mask: 40000000
>  | fanotify mnt_id:       13 mask:        1 ignored_mask: 40000000
> 
> To minimize impact on general fsnotify code the new functionality
> is gathered in fs/notify/fdinfo.c file.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: James Bottomley <jbottomley@parallels.com>
> CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Matthew Helsley <matt.helsley@gmail.com>
> CC: "J. Bruce Fields" <bfields@fieldses.org>
> CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>

Acked-by: Pavel Emelyanov <xemul@parallels.com>
