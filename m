Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2HNOV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:21:57 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9984 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2HNOVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:21:55 -0400
Message-ID: <502A5EFC.7030504@parallels.com>
Date: Tue, 14 Aug 2012 18:21:48 +0400
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
Subject: Re: [patch 2/8] procfs: Convert /proc/pid/fdinfo/ handling routines
 to seq-file
References: <20120814140342.354405844@openvz.org> <20120814140619.952738624@openvz.org>
In-Reply-To: <20120814140619.952738624@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 06:03 PM, Cyrill Gorcunov wrote:
> This patch converts /proc/pid/fdinfo/ handling routines to seq-file which
> is needed to extend seq operations and plug in auxiliary fdinfo provides
> from subsystems like eventfd/eventpoll/fsnotify.
> 
> Note the proc_fd_link no longer call for proc_fd_info, simply because
> proc_fd_info is converted to seq_fdinfo_open (which is seq-file open()
> prototype), moreover in further patches I need to provide two seq_fdinfo_open
> variants -- one with CONFIG_CHECKPOINT_RESTORE and one without this
> symbol. All in one -- this will look more messy then.
> 
> Also, to eliminate code duplication (and Pavel's concerns) the fdinfo_open_helper
> function introduced which is used in both seq_fdinfo_open and proc_fd_link.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: James Bottomley <jbottomley@parallels.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

