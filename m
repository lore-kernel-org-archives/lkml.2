Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab2C2Ua0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:30:26 -0400
Received: from mailhost.anl.gov ([130.202.113.50]:63958 "EHLO mailhost.anl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223Ab2C2UaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:30:21 -0400
X-Greylist: delayed 1091 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Mar 2012 16:30:21 EDT
From: Karl Pickett <kjp@ci.uchicago.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Is prctl(PR_SET_CHILD_SUBREAPER) going to break my code which checks getppid == 1?
Date: Thu, 29 Mar 2012 15:12:07 -0500
Message-Id: <46799FA3-D575-4A2D-8DEB-CE5149A4110D@ci.uchicago.edu>
Cc: kay.sievers@vrfy.org, Oleg Nesterov <oleg@redhat.com>,
        Lennart Poettering <lennart@poettering.net>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re: http://thread.gmane.org/gmane.linux.kernel/1236479

I'm wondering if this is going to break code that checks getppid() == 1?

I have a TCL/TK GUI app that spawns ssh.  I want the ssh to die immediately if the GUI process crashes, so ssh is launched with a wrapper c program that does:

   prctl(PR_SET_PDEATHSIG, SIGHUP);
   if (getppid() == 1) /* parent died already? */
       return 0;

So what is getppid() going to return for some user using this new 'session manager reaper'?  How else am I supposed to do proper processes supervision (with TCL/TK as a parent...)?  Also, this program is open source but we distribute binaries that work on as many platforms as possible... we find most users don't want to compile things.





