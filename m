Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009Ab2FGPFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 11:05:01 -0400
Received: from 8bytes.org ([85.214.48.195]:55938 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab2FGPFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 11:05:00 -0400
Date: Thu, 7 Jun 2012 17:04:56 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Bryan Schumaker <bjschuma@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: NFS regression in v3.5-rc1: mount.nfs yells about incorrect mount
 option
Message-ID: <20120607150456.GO12795@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun  7 17:04:57 2012
X-DSPAM-Confidence: 0.9962
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4fd0c31928388313116471
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since Linux v3.5-rc1 I experience problems using NFS between my
machines. One of my test-machines gives me:

root@chrom:~# mount lemmy:/data/repos /data/lemmy
mount.nfs: an incorrect mount option was specified

The same works fine on v3.4. I tried to bisect but got different errors
in between. In the end, using every non-working case as bad, bisection
pointed to:

	db83335 NFS: Let mount data parsing set the NFS version

but that at that commit the kernel panics when trying to mount the NFS
tree. Please let me know if you need any additional information.

Regards,

	Joerg


