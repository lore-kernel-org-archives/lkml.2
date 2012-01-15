Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab2AOPah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 10:30:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab2AOPag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 10:30:36 -0500
Date: Sun, 15 Jan 2012 10:30:32 -0500
From: Dave Jones <davej@redhat.com>
To: Jason Dravet <dravet@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clarify WARNING: at fs/sysfs/dir.c:481 sysfs_add
Message-ID: <20120115153032.GA716@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jason Dravet <dravet@hotmail.com>, linux-kernel@vger.kernel.org
References: <SNT144-W1DC10F59BB90518BD3FBFDF820@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SNT144-W1DC10F59BB90518BD3FBFDF820@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 09:16:13AM -0600, Jason Dravet wrote:
 > 
 > This patch makes it clear that the problem is in the BIOS of the computer and not the kernel.  This patch applies to kernel 3.2.1.
 >  
 > Reported-by: Greg White <pcguy11@live.com>
 > Signed-off-by: Jason Dravet <dravet@hotmail.com>
 > Tested-by: Greg White <pcguy11@live.com>
 >  
 > --- dir.orig    2012-01-14 18:58:20.026745884 -0600
 > +++ dir.c    2012-01-14 19:52:33.011444581 -0600
 > @@ -479,6 +479,8 @@ int sysfs_add_one(struct sysfs_addrm_cxt
 >               (path == NULL) ? sd->s_name :
 >               strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
 >                      sd->s_name));
 > +        WARN(1, KERN_WARNING
 > +             "Your BIOS is broken.  Please contact your computer manufacturer.");
 >          kfree(path);
 >      }
 
That certainly isn't always the case. Incorrectly written drivers
have also taken this codepath before now.

	Dave
