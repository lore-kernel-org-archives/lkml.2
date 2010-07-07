Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab0GGPBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:01:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19854 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab0GGPBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:01:23 -0400
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <andreas.dilger@oracle.com>
In-Reply-To: <87eifgfsez.fsf@linux.vnet.ibm.com>
Date: Wed, 7 Jul 2010 01:40:53 -0600
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2DC68584-15A8-4C48-8E65-E7EF1DCEEAD0@oracle.com>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <871vbn2mk9.fsf@linux.vnet.ibm.com> <20100702064108.64034561@notabene.brown> <87iq4y29a6.fsf@linux.vnet.ibm.com> <20100706161002.GD7387@fieldses.org> <87eifgfsez.fsf@linux.vnet.ibm.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1078)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C3496A9.0084:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-06, at 11:09, Aneesh Kumar K. V wrote:
> On Tue, 6 Jul 2010 12:10:02 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
>> ... I don't understand why both need to come in the same system call.
>> Is it purely an efficiency question?  If so, why do you expect this to
>> be significant?
> 
> Since we know that system wide file handle should include a file system
> identifier and a file identifier my plan was to retrieve both in the
> same syscall.

Won't having it be in a separate system call be racy w.r.t. doing the pathname lookup twice?

>> A filesystem uuid seems like a generally useful thing (maybe more so
>> than a filehandle), so it'd seem worth figuring out how to export that
>> separately.
>> 
> 
> I can add a new syscall that returns 
> 
> struct fs_uuid {
>       u8 fs_uuid[16];  
> };
> 
> long sys_get_fs_uuid(int dfd, char *name, struct fs_uuid *fsid, int flag);

While this might be useful, I think the file handle should identify the filesystem itself.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

