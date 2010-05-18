Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab0ERWc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:32:28 -0400
Received: from sous-sol.org ([216.99.217.87]:56086 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751742Ab0ERWc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:32:26 -0400
Date: Tue, 18 May 2010 15:32:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: compile fix, struct file forward declaration
Message-ID: <20100518223219.GJ8301@sequoia.sous-sol.org>
References: <20100518164409.8b19c786.sfr@canb.auug.org.au>
 <20100518140226.GB24113@kroah.com>
 <20100518210607.GI8301@sequoia.sous-sol.org>
 <20100518212448.GA31331@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518212448.GA31331@kroah.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 04:44:09PM +1000, Stephen Rothwell wrote:
> After merging the driver-core tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> cc1: warnings being treated as errors
> In file included from include/linux/kobject.h:21,
>                  from include/linux/device.h:17,
>                  from arch/powerpc/lib/devres.c:10:
> include/linux/sysfs.h:97: error: 'struct file' declared inside parameter list
> include/linux/sysfs.h:97: error: its scope is only this definition or
> declaration, which is probably not what you want
> include/linux/sysfs.h:99: error: 'struct file' declared inside parameter list
> include/linux/sysfs.h:101: error: 'struct file' declared inside parameter list
> 
> and many more (arch/powerpc is built with -Werror (as do some other
> architectures)) and lots of similar warnings ...

Add missing forward declaration

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/sysfs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 2a0d278..f06b1f1 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -86,6 +86,7 @@ struct attribute_group {
 
 #define attr_name(_attr) (_attr).attr.name
 
+struct file;
 struct vm_area_struct;
 
 struct bin_attribute {
