Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab0KQAWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:22:53 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:45967 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab0KQAWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:22:51 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=AcJjKCdO+C1gfaz5PU+ZhOHJ3th58JHw7dR6QJZP96w= c=1 sm=1
 a=-7GN7jtwYLcA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=t--1DsWkrR5rd0ZsQnsA:9
 a=kasANlzTJC5pF5bnJuQatxHv1ZoA:4 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20101116131451.GH4757@quack.suse.cz>
Date: Tue, 16 Nov 2010 18:22:47 -0600
Cc: Josef Bacik <josef@redhat.com>, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com
Content-Transfer-Encoding: 8BIT
Message-Id: <18ACAA85-8847-4B12-9839-F99FB6C7B3E4@dilger.ca>
References: <1289840723-3056-1-git-send-email-josef@redhat.com> <1289840723-3056-2-git-send-email-josef@redhat.com> <20101116111611.GA4757@quack.suse.cz> <20101116114346.GB4757@quack.suse.cz> <20101116125249.GB31957@dhcp231-156.rdu.redhat.com> <20101116131451.GH4757@quack.suse.cz>
To: Jan Kara <jack@suse.cz>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-16, at 07:14, Jan Kara wrote:
>> Yeah I went back and forth on this.  KEEP_SIZE won't change the behavior of PUNCH_HOLE since PUNCH_HOLE implicitly means keep the size.  I figured since its "mode" and not "flags" it would be ok to make either way accepted, but if you prefer PUNCH_HOLE means you have to have KEEP_SIZE set then I'm cool with that, just let me know one way or the other.
> 
> So we call it "mode" but speak about "flags"? Seems a bit inconsistent.  
> I'd maybe lean a bit at the "flags" side and just make sure that only one of FALLOC_FL_KEEP_SIZE, FALLOC_FL_PUNCH_HOLE is set (interpreting FALLOC_FL_KEEP_SIZE as allocate blocks beyond i_size). But I'm not sure what others think.

IMHO, it makes more sense for consistency and "get what users expect" that these be treated as flags.  Some users will want KEEP_SIZE, but in other cases it may make sense that a hole punch at the end of a file should shrink the file (i.e. the opposite of an append).

Cheers, Andreas





