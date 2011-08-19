Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1HSRlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:41:42 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:51890 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751727Ab1HSRll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:41:41 -0400
Message-ID: <4E4EA190.7080905@coly.li>
Date: Sat, 20 Aug 2011 01:46:56 +0800
From: Coly Li <i@coly.li>
Reply-To: i@coly.li
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; zh-CN; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: djwong@us.ibm.com
CC: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Joel Becker <jlbec@evilplan.org>, Mingming Cao <cmm@us.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] ext4 metadata checksumming design
References: <20110817032519.GN20655@tux1.beaverton.ibm.com>
In-Reply-To: <20110817032519.GN20655@tux1.beaverton.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1390:box585.bluehost.com:colyli:coly.li} {sentby:smtp auth 118.143.39.4 authed with i@coly.li}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年08月17日 11:25, Darrick J. Wong Wrote:
> Hi all,
> 
> I've created a page on the ext4 wiki outlining the patchset that I'm working on
> to add metadata checksumming to ext4.  The page can be found at this address:
> https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
> 

Hi Darrick,

I just go through the proposal, have on objection for most of the text. Only some things want to confirm,
1) If a metadata_csum enabled file system is metadata_csum disabled, it should be better to mark the block group or
inode whether the existing (disabled) checksum is valid or not. So if people re-enable metadata_csum, we can save quite
a lot of time to re-build check sums for all metadata objects.
2) In no-journal mode, every time when we modify the metadata objects, we may have to hold a lock, calculate the check
sum, and release the lock, which may introduce performance regression. I hope this is only my unnecessary over worry.

BTW, an engineer in Taobao kernel team, is trying to count different meta data objects I/O in run time now. One of the
first efforts, is trying to unify a set of routines to read or dirty meta data object blocks. A.k.a something (might)
like ext4_read_ext_block(), ext4_read_idx_block(), ... etc. Then the counting routines can be added inside the meta data
object blocks I/O routines. So far, it seems the modification is not trivial, needs more study on the code. Anyway,
since you mentioned on the wiki page, just let you know what we are doing now :-)

P.S. The idea of meta data I/O counting is to help us understanding the I/O characteristic of our online servers running
Ext4 file systems, which is the basic material for further I/O performance optimization.

Thanks.
-- 
Coly Li
