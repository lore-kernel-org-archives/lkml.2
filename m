Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0ENSky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:40:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33902 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab0ENSkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:40:52 -0400
Date: Fri, 14 May 2010 19:40:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andreas Dilger <andreas.dilger@oracle.com>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Serge Hallyn <serue@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       Steven French <sfrench@us.ibm.com>,
       Philippe Deniel <philippe.deniel@CEA.FR>,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
Message-ID: <20100514184044.GV30031@ZenIV.linux.org.uk>
References: <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com>
 <20100513084310.5212728b@notabene.brown>
 <871vdg2ulx.fsf@linux.vnet.ibm.com>
 <20100513171114.1629086b@notabene.brown>
 <51B2B398-99A7-43BF-A074-ACFBBA318DF7@oracle.com>
 <8739xvevbw.fsf@linux.vnet.ibm.com>
 <878w7n1xb3.fsf@linux.vnet.ibm.com>
 <B93EA6D0-4D21-46B2-988C-A7A307EBE0B7@oracle.com>
 <20100514172510.GU30031@ZenIV.linux.org.uk>
 <87d3wye49b.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d3wye49b.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 11:48:24PM +0530, Aneesh Kumar K. V wrote:

> How about
> sys_open_by_handle(int mountdirfd,
>                   struct file_handle __user *ufh, int open_flag)
> 
> and we validate the UUID present in the file_handle by using mountdirfd
> vfsmount. In otherwords we drop the UUID based vfsmount lookup, But
> still add UUID as a part of file handle ?

IDGI.  If you have decided upon the mountdirfd, why bother with rechecking?
You still need to handle the case when fs tells you to take a hike because
fileid was invalid.  What does duplicate uuid check in the kernel buy you?
