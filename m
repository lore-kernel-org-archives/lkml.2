Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab1BXVR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:17:57 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21273 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1BXVR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:17:56 -0500
MIME-Version: 1.0
Message-ID: <c4d12fe2-2175-4d59-9ef2-e6d5996023f0@default>
Date: Thu, 24 Feb 2011 13:16:34 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: aneesh.kumar@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: encode_fh: have inode but no dentry
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D66CB02.0022:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aneesh --

I see you are continuing with encode_fh related
development so I thought I would bring this up
with you.

I have a need to call the encode_fh op in a
situation where I have an inode but not a dentry,
and calling d_find_alias(inode) sometimes returns
NULL.  In my usage, connectable is always zero, so
having just the inode should be sufficient to get
useful results from encode_fh, at least for the
filesystems I've looked at.

What I'd like to see is the generic interface to
encode_fh extended to support this situation,
probably by passing inode as another parameter,
perhaps specified so that it can only be non-NULL
if connectable==0 and dentry==NULL.

Such a change would require a patch that touched
nearly every filesystem so it's clearly not to
be taken lightly.

Any thoughts on this?

Thanks,
Dan
