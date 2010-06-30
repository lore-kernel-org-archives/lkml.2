Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0F3Jdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:33:54 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:16939 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0F3Jdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:33:51 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=_meyTIPSnzEA:10 a=ygRHs6EKU7oA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=WRyMqZt7usigIdCacfwA:9
 a=Xfe715nsxeLss5Ol7TwLUKFMYUIA:4 a=CjuIK1q_8ugA:10
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1277862536.9326.3.camel@heimdal.trondhjem.org>
Date: Wed, 30 Jun 2010 03:33:49 -0600
Cc: David Howells <dhowells@redhat.com>, viro@ZenIV.linux.org.uk,
       smfrench@gmail.com, jlayton@redhat.com, mcao@us.ibm.com,
       aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, sjayaraman@suse.de,
       linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CE3451EE-F8B2-47EF-AC1C-4EEEBE68B30F@dilger.ca>
References: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk> <1277862536.9326.3.camel@heimdal.trondhjem.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-29, at 19:48, Trond Myklebust wrote:
>> When the system call is executed, the struct_version ID and query_flags bitmask are read from the buffer to work out what the user is requesting.
> 
> Yes, but could we please also add a flag that allows you to specify that
> the kernel _must_ provide up to date attributes.

To my reading, if the query_flags are set in the input buffer, then the attributes MUST be fetched.  If they are unset, then they MAY be fetched, and the corresponding query_flags will be set in the return buffer.  If the query_flags are not set in the return buffer then I assume the output values are undefined.

In discussions about the proposed "statlite()" API (which this is very similar to) it was desirable that there be separate flags for the individual fields (at least AMC_TIME should be split), since it isn't always clear whether it is "free" to get all of these timestamps, if just one is desired.  For Lustre, in particular, the mtime is stored with the file data (where it is updated), and it is more costly to get this if it isn't needed.

Cheers, Andreas





