Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1BGQCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 11:02:51 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47204 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1BGQCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 11:02:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I/HwPWvzeT8L9PCNcwWRx+TTReUlUWkDZZZNiLKeQoYdViCHRWgv/HFuOaAWeheMTT
         ugkNcf4SdJVcK8bOm9555yBmfZzO6Xk0DGiPdeSP/bpDm9ZDHZQxShjTTbobFQrGIhDr
         tVOgt/SOVGxlfm5cRH9CTuUgNIjNQM2/q2B8g=
Date: Mon, 7 Feb 2011 18:01:27 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Simon Horman <horms@verge.net.au>,
        Haren Myneni <hbabu@us.ibm.com>,
        Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCH v3 -next] Documentation: Improve crashkernel= description
Message-ID: <20110207160127.GA25828@laptop>
References: <20110206154108.GA16542@laptop> <20110206215733.GB26233@verge.net.au> <20110206201448.4a259575.rdunlap@xenotime.net> <20110207113054.GA10388@laptop> <20110207142550.GA7437@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110207142550.GA7437@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 09:25:50AM -0500, Vivek Goyal wrote:
> On Mon, Feb 07, 2011 at 01:30:54PM +0200, Ahmed S. Darwish wrote:
> > 
> > Had to explore two C code files to make sense of the 'crashkernel='
> > kernel parameter values.  Improve the situation.
> > 
> 
> Did you look at Documentation/kdump/kdump.txt before looking into the
> code. I thought kdump.txt explained the meaning of crashkernel= well.
> 
> In case if it was not obivious that for further details look into
> kdump.txt, I will suggest to add a line asking reader to look into
> kdump.txt for more details.
> 

Yes, I jumped to the code first :-) Here's a new patch with the link:

(Also applicable over latest -rc3)

==>

Complete the crashkernel= kernel parameter documentation.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 89835a4..050b0e5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -545,16 +545,20 @@ and is between 256 and 4096 characters. It is defined in the file
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
+			is selected automatically. Check
+			Documentation/kdump/kdump.txt for further details.
 
 	crashkernel=range1:size1[,range2:size2,...][@offset]
 			[KNL] Same as above, but depends on the memory
 			in the running system. The syntax of range is
 			start-[end] where start and end are both
 			a memory unit (amount[KMG]). See also
-			Documentation/kdump/kdump.txt for a example.
+			Documentation/kdump/kdump.txt for an example.
 
 	cs89x0_dma=	[HW,NET]
 			Format: <dma>


> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 

thanks,

-- 
Darwish
http://darwish.07.googlepages.com
