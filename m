Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1KSJeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 04:34:10 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44503 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab1KSJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 04:34:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andreas Dilger <adilger@dilger.ca>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, agruen@kernel.org,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <1318951981-5508-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1318951981-5508-22-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20111019222021.GB1874@fieldses.org>
	<87k4805alx.fsf@linux.vnet.ibm.com>
	<20111020091434.GC5444@fieldses.org>
	<20111020091946.GA23773@infradead.org>
	<87aa8w53kj.fsf@linux.vnet.ibm.com>
	<20111020174915.GA9987@fieldses.org>
	<E394C0CC-6124-42FD-9962-A061DC4784E3@dilger.ca>
Date: Sat, 19 Nov 2011 01:35:11 -0800
In-Reply-To: <E394C0CC-6124-42FD-9962-A061DC4784E3@dilger.ca> (Andreas
	Dilger's message of "Thu, 20 Oct 2011 13:49:33 -0600")
Message-ID: <m1lircxxo0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/n9FfNZ8oVKZ2GyHExUkFw/Bu6l5zMq7o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andreas Dilger <adilger@dilger.ca>
X-Spam-Relay-Country: **
Subject: Re: [PATCH -V7 21/26] richacl: xattr mapping functions
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger <adilger@dilger.ca> writes:

> Just as an FYI, from back when we were trying to port Lustre to Solaris,
> Solaris itself uses a 64-bit "FUID" (32-bit UID + 32-bit namespace) to
> handle this.
>
> It has a table for arbitrary mapping of 128-bit Windows domains to a
> 32-bit FUID namespace (don't know much detail here, sorry), and it is
> (reasonably) expected that a single system will not be in more than
> 2^32 namespaces at once.  This keeps the datatypes sane (u64 or 2x u32)
> and doesn't put much complexity into the filesystem/kernel.  For most
> uses, the high 32-bit value is 0 (local Unix domain).

Interesting.  For now it looks to me like a fixed partitions of a uid
into a namespace identifier and a normal uid is a brittle path to walk.

I am looking at using something slightly more dynamic.  Here for your
user namespace you get this range of uids.  That nests better and
allows for more flexibility in the future.

I think I can mostly keep filesystems where they don't care.  With just
a few places changes where we take the filesystem uid and map it into
what we store in the vfs cache.  And when we read the uid value out
of the vfs cache and map it into the id value that the filesystem
needs.

Eric
