Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab1BNK5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:57:08 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37064 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1BNK5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:57:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=F5VJrzXxwB3vVAEjc+ufSLH+asX2Rp1azxc9LBghWkxK6/aOFOKvieHBdUhKmPsmhj
         gKaAjt47QFxThWkZ2+2D4RO1YJP+QHCRTcLG0mtBbtq2PBceNxxxOI3tymgzTs1eFXR0
         711x6PrIsiGdaQJmMev8l/KjvGs0cY8CC1mek=
Date: Mon, 14 Feb 2011 11:56:59 +0100
From: Tejun Heo <tj@kernel.org>
To: mszeredi@suse.cz, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, kovariadam@gmail.com
Subject: FUSE triggering BUG through blkdev_put()
Message-ID: <20110214105659.GB18742@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please take a look at the following bug.

 https://bugzilla.kernel.org/show_bug.cgi?id=28642

The bug title and description are completely misleading but the
problem seems to have been caused by the recent eviction related
changes.  FUSE ends up blkdev_put'ting while I_CLEAR is still set on
the blkdev's inode triggering BUG_ON() in iput().

Thanks.

-- 
tejun
