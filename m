Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab2HUMkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:40:35 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2347 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab2HUMkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:40:33 -0400
Message-ID: <503381B0.7040705@parallels.com>
Date: Tue, 21 Aug 2012 16:40:16 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
References: <20120820183225.GB4911@fieldses.org> <20120820190606.GE27443@moon> <20120820193204.GD5779@fieldses.org> <50335261.5090504@parallels.com> <87wr0sle4v.fsf@skywalker.in.ibm.com> <503367CB.9080609@parallels.com> <20120821105424.GA7670@moon> <50336C51.60501@parallels.com> <20120821121155.GC9483@fieldses.org> <50337D87.90607@parallels.com> <20120821122908.GE9483@fieldses.org>
In-Reply-To: <20120821122908.GE9483@fieldses.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> Al, Bruce, Aneesh,
>>>>
>>>> What if we calculate the handle at the time we do have struct path at hands (i.e.
>>>> when we create the inotify) and store it on the inotify structure purely to be 
>>>> shown later in proc. Would that be acceptable?
>>>
>>> Was it the lack of a dentry that was really the problem?  I thought it
>>> was just the fact that not all filesystems support filehandles.
>>
>> Initial problem -- we don't know what is being watched by an inotify fd.
>>
>> Having a dentry somewhere was the 1st attempt to solve this -- keep a path
>> in inotify and show it when required. It doesn't work since holding a ref on
>> path changes the behavior of watched inode (we cannot rename/unlink/remount
>> it the same way as we could before patching the kernel).
> 
> OK.  So if you don't mind the fact that there are filesystems with
> inotify support but not filehandle support, then I think generating a
> filehandle early as you describe would work.  I guess it's a little more
> memory per watched inode.

Great! Thanks, Bruce, we'll rework the patch accordingly :)

> --b.
> .
> 

Thanks,
Pavel
