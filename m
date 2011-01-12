Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab1ALC7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 21:59:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756190Ab1ALC7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 21:59:42 -0500
Message-ID: <4D2D1936.2070201@cn.fujitsu.com>
Date: Wed, 12 Jan 2011 11:00:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs build failure in latest git
References: <4D2CE678.10607@garzik.org>
In-Reply-To: <4D2CE678.10607@garzik.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-12 10:59:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-12 10:59:11
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Tree as of commit 7bc4a4ce68f8c6d064ea949446852e996526f692 dies during btrfs build on x86-64:
> 
>   CC [M]  fs/btrfs/ctree.o
> In file included from fs/btrfs/ctree.c:21:0:
> fs/btrfs/ctree.h:1003:17: error: field ‘super_kobj’ has incomplete type
> fs/btrfs/ctree.h:1074:17: error: field ‘root_kobj’ has incomplete type
> make[2]: *** [fs/btrfs/ctree.o] Error 1
> make[1]: *** [fs/btrfs] Error 2
> make: *** [fs] Error 2
> 

Should be caused by this commit:

commit 57cc7215b70856dc6bae8e55b00ecd7b1d7429b1
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Mon Jan 10 08:18:25 2011 +0200

    headers: kobject.h redux
    
    Remove kobject.h from files which don't need it, notably,
    sched.h and fs.h.

So the fix is to include kobject.h explicitly in ctree.h.
