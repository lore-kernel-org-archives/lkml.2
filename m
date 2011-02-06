Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1BFPlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:41:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54001 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab1BFPlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:41:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=t6W4vkCCFRt9I6fTIRw4s343Tnw9DGUv4fOr385iLMZKGCn1gI5FXN11+iIWHLnM/O
         L5ndq+eMmRYEWpdmb8Y8n3ADUz4rNUqSNbUEL1vpu3pA6dWDYjIL9Zr3DMOs6+zIwVWN
         oQMhT2eG/hZ5WTKm5f/tas+hGWxpPVjkjL0kU=
Date: Sun, 6 Feb 2011 17:41:08 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Vivek Goyal <vgoyal@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH -next] Documentation: Improve crashkernel= description
Message-ID: <20110206154108.GA16542@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Also applicable over 2.6.38-rc3)

Had to explore two C code files to make sense of the 'crashkernel='
kernel parameter values.  Improve the situation.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 89835a4..8f26b42 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -545,9 +545,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format:
 			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
 
-	crashkernel=nn[KMG]@ss[KMG]
-			[KNL] Reserve a chunk of physical memory to
-			hold a kernel to switch to with kexec on panic.
+	crashkernel=size[KMG][@offset[KMG]]
+			[KNL] Using kexec, Linux can switch to a 'crash kernel'
+			upon panic. This parameter reserves the physical
+			memory region [offset, offset + size] for that kernel
+			image. If the '@offset' part was ignored, Linux finds
+			a suitable crash image start address automatically.
 
 	crashkernel=range1:size1[,range2:size2,...][@offset]
 			[KNL] Same as above, but depends on the memory

regards,

-- 
Darwish
http://darwish.07.googlepages.com
