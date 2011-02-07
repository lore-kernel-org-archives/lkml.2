Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1BGLbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:31:08 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63983 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab1BGLbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:31:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dA/JTp0REXwJ8UWfmlvjijH0bbhH3f40muy5hiJlEDyMr1HeEmR+jicZML7qUnTlsG
         lejKGTqO+PF5AT6rTlVqzp/1szm3Ai4jqOs2wgtxOGfN7aKb4w4L5KfklDLWlpc2T+T3
         peK1STZKw8cOEgwVYD6s9BqSY+APh0tixjJsE=
Date: Mon, 7 Feb 2011 13:30:54 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Simon Horman <horms@verge.net.au>, Vivek Goyal <vgoyal@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>,
        Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH v2 -next] Documentation: Improve crashkernel= description
Message-ID: <20110207113054.GA10388@laptop>
References: <20110206154108.GA16542@laptop> <20110206215733.GB26233@verge.net.au> <20110206201448.4a259575.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110206201448.4a259575.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Had to explore two C code files to make sense of the 'crashkernel='
kernel parameter values.  Improve the situation.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 89835a4..5ad9980 100644
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
+			image. If '@offset' is omitted, then a suitable offset
+			is selected automatically.
 
 	crashkernel=range1:size1[,range2:size2,...][@offset]
 			[KNL] Same as above, but depends on the memory

-- 
Darwish
http://darwish.07.googlepages.com
