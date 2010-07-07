Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab0GHEbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:31:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49105 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0GHEbM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:31:12 -0400
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <andreas.dilger@oracle.com>
In-Reply-To: <20100707213921.2edbb3a1@lxorguk.ukuu.org.uk>
Date: Wed, 7 Jul 2010 17:54:23 -0600
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>,
       "viro@zeniv.linux.org.uk Viro" <viro@zeniv.linux.org.uk>,
       "corbet@lwn.net Corbet" <corbet@lwn.net>,
       "hooanon05@yahoo.co.jp Okajima" <hooanon05@yahoo.co.jp>,
       linux-fsdevel@vger.kernel.org,
       "sfrench@us.ibm.com French" <sfrench@us.ibm.com>,
       "philippe.deniel@CEA.FR Deniel" <philippe.deniel@CEA.FR>,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A55CC567-FA15-48B5-9274-181CC3462D91@oracle.com>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <871vbn2mk9.fsf@linux.vnet.ibm.com> <20100702064108.64034561@notabene.brown> <87iq4y29a6.fsf@linux.vnet.ibm.com> <20100706161002.GD7387@fieldses.org> <87eifgfsez.fsf@linux.vnet.ibm.com> <2DC68584-15A8-4C48-8E65-E7EF1DCEEAD0@oracle.com> <20100707150535.GB24360@fieldses.org> <5920F408-E923-4467-A6A9-6C0923C00927@oracle.com> <20100707213921.2edbb3a1@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1078)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C355472.0131:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-07, at 14:39, Alan Cox wrote:
>> I think you are assuming too much about the use of the file handle.  What I'm interested in is not a userspace file server, but rather a more efficient way to have 10000's to millions of clients to be able to open the same regular file, without having to do full path traversal for each one.
> 
> The unix security model requires the traversal. In that respect it
> differs significantly from some other OS's that did have handle based
> direct opens and treat directories as a lookup and translation index only.

There IS full path traversal at the time the file handle is generated, so it meets these requirements.  This isn't really conceptually any different than fd passing over a unix socket on a local system, but passing the fd between user processes (via an out-of-band communication method, likely an MPI broadcast message) that are running on different nodes all accessing the same distributed filesystem.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

