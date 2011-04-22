Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab1DVXdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:33:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51423 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab1DVXde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:33:34 -0400
Message-ID: <4DB21037.2060604@oracle.com>
Date: Fri, 22 Apr 2011 16:33:11 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Andreas Dilger <adilger@dilger.ca>
CC: Eric Blake <eblake@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com> <4DB1AF6F.4040706@redhat.com> <4DB1B37C.9070406@oracle.com> <4DB1B4F1.8070109@redhat.com> <4DB1B62B.3000700@oracle.com> <B7EE7E9A-083C-4914-8A69-4DD3448D06B3@dilger.ca>
In-Reply-To: <B7EE7E9A-083C-4914-8A69-4DD3448D06B3@dilger.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DB21043.001B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 11:06 AM, Andreas Dilger wrote:
> Sure, there are lots of wasted syscalls, but in this case the cost of doing extra SEEK_DATA and SEEK_HOLE operations may be fairly costly. This involves scanning the whole disk layout, possibly over a network, which might need tens or hundreds of disk seeks to read the metadata, unlike regular SEEK_SET.
>
> Even SEEK_END is somewhat costly on a network filesystem, since the syscall needs to lock the file size in order to determine the end of the file, which can block other threads from writing to the file.
>
> So while I agree that the Linux mantra that "syscalls are cheap" is true if those syscalls don't actually do any work, I think it also ignores the cost of what some syscalls need to do behind the scenes.

You have a point. I was just reviewing the possible patch for ocfs2
and it looks heavy.

One option is to scrap SEEK_* and make another syscall llfind() with FIND_*.
Or, do both.
