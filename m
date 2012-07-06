Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab2GFUdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:33:51 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:53228 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab2GFUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:33:50 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=FP525ZgouhuBzdRj67Bs62Mgfb5xNsXKhjg+5I7rEFcf99dwnGqXaoo7I7rQ
	zMZq3u+lnURQdJgJuqGWGSAjvK3MVQ3BQO4bZ3WkqJVFyRXilZQM2Aqvj
	BAmmHiA3wgGQuzPlJwnHk0Rd8Duqipg4PCUjFnRF1xlM8g+lOFi2JM=;
X-Spam-Processed: mail.digidescorp.com, Fri, 06 Jul 2012 15:33:48 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=15345d67fc=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341606824.2214.14.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 06 Jul 2012 15:33:44 -0500
In-Reply-To: <87pq8bokcp.fsf@devron.myhome.or.jp>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	 <1341342576-15394-3-git-send-email-steve@digidescorp.com>
	 <87pq8bokcp.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 20:07 +0900, OGAWA Hirofumi wrote: 
> Please don't add new lock_super() usage if it is not necessary. Almost
> all of lock_super() just replaced lock_kernel() usage. It rather should
> be removed in future.  Probably, this should use inode->i_mutex instead.
> 
> BTW, the above issue is same with all of directory read.

I don't think there's really an alternative here. The cases addressed by
this patch all involve walking on-disk structures via
unofficial/temporary inodes created from information in the NFS handle
(i.e., outside the normal inode creation paths). When this process is
successful we end up with "official" connected inodes/dentries, but
getting there is really a "bottom up" strategy instead of the usual "top
down" approach.

Because the "bottom up" method is lacking guarantees that "top down"
takes for granted - i.e., that a cluster on disk that's supposed to be a
directory actually *is* a directory -  I am adding some defensive code
in the next spin of the patch.

Steve


