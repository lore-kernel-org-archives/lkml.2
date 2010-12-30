Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0L3Ctm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 21:49:42 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50494 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0L3Ctl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 21:49:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=eEi66S7U5e3IGF0PyUxoyvTfXlVHUrcvizI/rD6qUB8SHMlX0sA7VgX87+md6QF+9Q
         m4vU5MWiDFdQQN8CIgfa3fi7CLC6DOBimU9aDlCFuvga2xN1pgjbYPTuHzFhKdQSvB8A
         sSz1PuQcPNaeVgjSY99WhtmpAhBK4lL8vxVsM=
Date: Thu, 30 Dec 2010 10:49:33 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Linux 2.6.37-rc8 (no fb)
Message-ID: <Pine.LNX.4.64.1012301045170.5207@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Dec 30, 2010 at 4:16 AM, Jesse Barnes <jbarnes@virtuousgeek.org> 
wrote:

> Randy, Jeff and Alex, does the below help at all?  If so, it may be the
> minimal fix we want for 2.6.37.

Jesse,

Yes, that worked for me. I improved on the patch a bit below.

Thanks,
Jeff


--- a/drivers/gpu/drm/i915/intel_bios.c	2010-12-29 13:35:57.000000000 +0800
+++ a/drivers/gpu/drm/i915/intel_bios.c	2010-12-30 10:18:39.000000000 +0800
@@ -262,7 +262,10 @@
  	if (general) {
  		dev_priv->int_tv_support = general->int_tv_support;
  		dev_priv->int_crt_support = general->int_crt_support;
-		dev_priv->lvds_use_ssc = general->enable_ssc;
+
+		/* force disable until we can parse this correctly */
+		dev_priv->lvds_use_ssc = (IS_GEN5(dev) || IS_GEN6(dev)) ?
+			0 : general->enable_ssc;

  		if (dev_priv->lvds_use_ssc) {
  			if (IS_I85X(dev))
