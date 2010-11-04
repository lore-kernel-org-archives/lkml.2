Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab0KDGIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 02:08:24 -0400
Received: from mailout1.paradigmgeo.com ([12.146.216.194]:42975 "EHLO
	mailout1.paradigmgeo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0KDGIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 02:08:23 -0400
From: Gregory Giguashvili <Gregory.Giguashvili@PDGM.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Change signal mask after vfork/clone system call
Thread-Topic: Change signal mask after vfork/clone system call
Thread-Index: ActvYrwDS1Qou4ZiSWG8vicGxd93awMg65jw
Date: Thu, 4 Nov 2010 06:08:17 +0000
Message-ID: <DAF636D3923A51488784A1F985996EE8041FAA46@exil1.paradigmgeo.net>
References: <DAF636D3923A51488784A1F985996EE803FCB7B0@exil1.paradigmgeo.net>
In-Reply-To: <DAF636D3923A51488784A1F985996EE803FCB7B0@exil1.paradigmgeo.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.3.201]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Nov 2010 06:08:18.0105 (UTC) FILETIME=[ACBE7A90:01CB7BE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments on this issue? Is there a way to prevent signal mask inheritance when using vfork?

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Gregory Giguashvili
Sent: Tuesday, October 19, 2010 9:54 AM
To: linux-kernel@vger.kernel.org
Subject: Change signal mask after vfork/clone system call

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


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
---------------------------------------------------------------------------------------------------------------
This e-mail, including any attached files, may contain confidential and privileged information for the sole use of the intended recipient. Any review, use, distribution, or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive information for the intended recipient), please contact the sender by reply e-mail and delete all copies of this message.


