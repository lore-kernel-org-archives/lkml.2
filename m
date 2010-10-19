Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851Ab0JSIEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:04:55 -0400
Received: from mailout1.paradigmgeo.com ([12.146.216.194]:51576 "EHLO
	mailout1.paradigmgeo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab0JSIEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:04:51 -0400
X-Greylist: delayed 669 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2010 04:04:51 EDT
From: Gregory Giguashvili <Gregory.Giguashvili@PDGM.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Change signal mask after vfork/clone system call
Thread-Topic: Change signal mask after vfork/clone system call
Thread-Index: ActvYrwDS1Qou4ZiSWG8vicGxd93aw==
Date: Tue, 19 Oct 2010 07:53:36 +0000
Message-ID: <DAF636D3923A51488784A1F985996EE803FCB7B0@exil1.paradigmgeo.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Oct 2010 07:53:37.0825 (UTC) FILETIME=[BCFB3910:01CB6F62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For new processes created by vfork, while signals are blocked using pthread_sigmask: is there a way in a multi-threaded parent to safely unblock signals before the new process is started? Does pthread_atfork like functionality exist for vfork-ed processes maybe?

Ideally, the following code should work, except we're not allowed to call anything in the child process besides exec family of functions.

sigmask_t new;
sigmask_t old;
sigaddset (&new, SIGCHLD);
pthread_sigmask (SIG_BLOCK, &new, &old);

switch (vfork ()) {
case 0: // parent
	break;
case -1: // error
	break;
default: // child
	pthread_sigmask (SIG_SETMASK, &old, NULL);
	execv (...);
	_exit (-1);
}

Finally, if using fork should be efficient for starting processes from applications with heavy VM/RSS memory footprint, this question becomes obsolete.

Thanks
Giga

---------------------------------------------------------------------------------------------------------------
This e-mail, including any attached files, may contain confidential and privileged information for the sole use of the intended recipient. Any review, use, distribution, or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive information for the intended recipient), please contact the sender by reply e-mail and delete all copies of this message.


