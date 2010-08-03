Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab0HCSgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 14:36:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64764 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab0HCSgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 14:36:47 -0400
Subject: Re: [PATCH V3 0/8] Cleancache: overview
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <andreas.dilger@oracle.com>
X-Priority: 3
In-Reply-To: <a7f4db53-c348-4cff-8762-7ea4031e4813@default>
Date: Tue, 3 Aug 2010 12:34:19 -0600
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>,
        ngupta@vflare.org, akpm@linux-foundation.org,
        Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
        Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, jeremy@goop.org,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@suse.de, Dave Mccracken <dave.mccracken@oracle.com>,
        riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <22A6238E-0BA4-4AB9-A4FA-28B206A47513@oracle.com>
References: <20100621231809.GA11111%ca-server1.us.oracle.com4C49468B.40307@vflare.org> <840b32ff-a303-468e-9d4e-30fc92f629f8@default> <20100723140440.GA12423@infradead.org> <364c83bd-ccb2-48cc-920d-ffcf9ca7df19@default> <a7f4db53-c348-4cff-8762-7ea4031e4813@default>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
X-Mailer: Apple Mail (2.1081)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C58617F.00FB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-03, at 11:35, Dan Magenheimer wrote:
> - The FS should be block-device-based (e.g. a ram-based FS
>  such as tmpfs should not enable cleancache)

When you say "block device based", does this exclude network filesystems?  It would seem cleancache, like fscache, is actually best suited to high-latency network filesystems.

> - To ensure coherency/correctness, inode numbers must be unique
>  (e.g. no emulating 64-bit inode space on 32-bit inode numbers)

Does it need to be restricted to inode numbers at all (i.e. can it use an opaque internal identifier like the NFS file handle)?  Disallowing cleancache on a filesystem that uses 64-bit (or larger) inodes on a 32-bit system reduces its usefulness.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

