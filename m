Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab0GNNLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:11:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0GNNLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:11:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: sound/oss-msnd-pinnacle: ioctl needs the inode
Date: Wed, 14 Jul 2010 15:11:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20100713144007.55d3abc9.sfr@canb.auug.org.au> <20100713103623.bfb0d9b8.randy.dunlap@oracle.com>
In-Reply-To: <20100713103623.bfb0d9b8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007141511.39507.arnd@arndb.de>
X-Provags-ID: V02:K0:E/E91t7SV4veK+2jQw1P2ON1RHoRvHXB1fqVJyl/Xp0
 mh1K5xvC7LnBIYyp3OfZnBPwYZP3uuYAoh6xY1Hv90z+R9/JLb
 84HJQZSjBGl+gVY5niHbZH989UqF8GPiE1tVCutxEUZTzfyhqo
 uufKfUfMQj3XtBA3ggkzF7nN8nwjkKGEl4/ME6SytXWfQw3p72
 1Gg2Urdmbuouvi01I5fWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This broke in sound/oss: convert to unlocked_ioctl, when I missed one
of the ioctl functions still using the inode pointer.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
On Tuesday 13 July 2010, Randy Dunlap wrote:
> On Tue, 13 Jul 2010 14:40:07 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Not unexpectedly, we got some conflicts with the arm defconfig files
> > today ...
> 
> 
> sound/oss/msnd_pinnacle.c:644:error: 'inode' undeclared (first use in this function)
> 

Sorry about that, my fault. Please apply.

I checked all the other files I touched in the same patch, they either did
not have this problem, or I had done it correctly.

--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -641,7 +641,7 @@ static int mixer_ioctl(unsigned int cmd, unsigned long arg)
 
 static long dev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	int minor = iminor(inode);
+	int minor = iminor(file->f_path.dentry->d_inode);
 	int ret;
 
 	if (cmd == OSS_GETVERSION) {
