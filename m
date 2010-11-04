Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab0KDQUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:20:53 -0400
Received: from mailout1.paradigmgeo.com ([12.146.216.194]:45034 "EHLO
	mailout1.paradigmgeo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab0KDQUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:20:49 -0400
From: Gregory Giguashvili <Gregory.Giguashvili@PDGM.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Change signal mask after vfork/clone system call
Thread-Topic: Change signal mask after vfork/clone system call
Thread-Index: ActvYrwDS1Qou4ZiSWG8vicGxd93awMg65jwAAOOfoAAEApcQP//44qA///XZgA=
Date: Thu, 4 Nov 2010 16:20:37 +0000
Message-ID: <DAF636D3923A51488784A1F985996EE804207065@exil1.paradigmgeo.net>
References: <DAF636D3923A51488784A1F985996EE803FCB7B0@exil1.paradigmgeo.net>
	<DAF636D3923A51488784A1F985996EE8041FAA46@exil1.paradigmgeo.net>
	<20101104094817.21548963@lxorguk.ukuu.org.uk>
	<DAF636D3923A51488784A1F985996EE804206DDF@exil1.paradigmgeo.net>
 <20101104154543.2a71cff1@lxorguk.ukuu.org.uk>
In-Reply-To: <20101104154543.2a71cff1@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.3.201]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Nov 2010 16:20:37.0735 (UTC) FILETIME=[37451F70:01CB7C3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And is there a reason you can't mask the signals, vfork and unmask them
> again after the parent continues?
The signals are already masked in all threads and there's a dedicated thread, catching signals with sigwait. The problem is that vfork inherits signal mask to a child process and 3rd party executables are not processing any signals because they're not using sigwait technique.

Now, I could unmask signals for the thread calling vfork, but it seems not a signal-safe solution to me because signals may arrive to this thread until I reestablish the mask. pthread_atfork call comes to rescue to address such issues for fork, but there seems to be nothing for vfork call.

Giga
---------------------------------------------------------------------------------------------------------------
This e-mail, including any attached files, may contain confidential and privileged information for the sole use of the intended recipient. Any review, use, distribution, or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive information for the intended recipient), please contact the sender by reply e-mail and delete all copies of this message.


