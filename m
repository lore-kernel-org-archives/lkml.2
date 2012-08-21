Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2HULJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:09:28 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19146 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab2HULJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:09:26 -0400
Message-ID: <50336C51.60501@parallels.com>
Date: Tue, 21 Aug 2012 15:09:05 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
References: <20120815092116.700948346@openvz.org> <20120815092409.591460800@openvz.org> <87fw7habo4.fsf@skywalker.in.ibm.com> <20120820163338.GN23596@moon> <20120820183225.GB4911@fieldses.org> <20120820190606.GE27443@moon> <20120820193204.GD5779@fieldses.org> <50335261.5090504@parallels.com> <87wr0sle4v.fsf@skywalker.in.ibm.com> <503367CB.9080609@parallels.com> <20120821105424.GA7670@moon>
In-Reply-To: <20120821105424.GA7670@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 02:54 PM, Cyrill Gorcunov wrote:
> On Tue, Aug 21, 2012 at 02:49:47PM +0400, Pavel Emelyanov wrote:
>>>>
>>>> However, if you have some better ideas on what information about inode should be exported
>>>> to the userspace please share.
>>>>
>>>
>>> Why not use name_to_handle(fd,...) and open_by_handle(handle,..) ?
>>
>> Because we don't have an fd at hands by the time we need to know the handle.
> 
> Yeah, this might be not clear from patchset itself but inotify marks carry
> inodes inside kernel thus it's inodes what we can use when we fetch information
> about targets and put it into fdinfo output.

Al, Bruce, Aneesh,

What if we calculate the handle at the time we do have struct path at hands (i.e.
when we create the inotify) and store it on the inotify structure purely to be 
shown later in proc. Would that be acceptable?

> 	Cyrill
> .

Thanks,
Pavel
