Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0I2Au2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:50:28 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:54514 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab0I2AuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:50:25 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "N.P.S. N.P.S." <napohybelskurwysynom2010@gmail.com>
cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-09-28-16-13 uploaded
In-reply-to: Your message of "Wed, 29 Sep 2010 02:27:55 +0200."
             <AANLkTimFbxc7MGdirSzdJ-YZbFFHBVn4JJhHcP46W1_4@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
            <AANLkTimFbxc7MGdirSzdJ-YZbFFHBVn4JJhHcP46W1_4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Date: Tue, 28 Sep 2010 20:49:44 -0400
Message-ID: <124506.1285721384@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4CA28D29.01A1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 02:27:55 +0200, "N.P.S. N.P.S." said:
> Hi,
> 
> 2010/9/29  <akpm@linux-foundation.org>:
> > The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
> 
> I wonder why are these two functions in include/linux/fs.h
> static inline void lock_flocks()
> {
> }
> 
> static inline void unlock_flocks()
> {
> }

Those were added as part of the kill-the-BKL project.  They used to be
done as #defines to lock_kernel and unlock_kernel, but became full-fledged
functions in this release.  Unfortunately, if you build with CONFIG_FILE_LOCKING=n
you need to provide a dummy stub, which is what was intended here.

Does the following (untested) fix the problem for you?

Signed-Off-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- linux-2.6.36-rc5-mmotm0928/include/linux/fs.h.dist	2010-09-28 20:46:29.276970365 -0400
+++ linux-2.6.36-rc5-mmotm0928/include/linux/fs.h	2010-09-28 20:47:34.221924470 -0400
@@ -1274,11 +1274,11 @@ static inline int lock_may_write(struct 
 	return 1;
 }
 
-static inline void lock_flocks()
+static inline void lock_flocks(void)
 {
 }
 
-static inline void unlock_flocks()
+static inline void unlock_flocks(void)
 {
 }
 

