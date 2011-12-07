Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1LGN7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:59:46 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64265 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233Ab1LGN7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:59:44 -0500
Subject: Re: [PATCH 1/2] PM / Usermodehelper: Introduce reference counting
 to solve usermodehelper_disabled race
From: Namhyung Kim <namhyung@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, dhowells@redhat.com,
        eparis@redhat.com, rjw@sisk.pl, kay.sievers@vrfy.org,
        jmorris@namei.org, tj@kernel.org, bp@amd64.org,
        linux-pm@vger.kernel.org
In-Reply-To: <4EDF5C61.4050204@linux.vnet.ibm.com>
References: <20111205212456.27496.35812.stgit@srivatsabhat.in.ibm.com>
	 <20111205212524.27496.58775.stgit@srivatsabhat.in.ibm.com>
	 <4EDD68E3.6050100@gmail.com>  <4EDF5C61.4050204@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Dec 2011 22:59:30 +0900
Message-ID: <1323266370.1471.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-12-07 (수), 18:00 +0530, Srivatsa S. Bhat:
> On 12/06/2011 06:29 AM, Namhyung Kim wrote:
> 
> > Hello,
> > 
> > 2011-12-06 오전 6:26, Srivatsa S. Bhat 쓴 글:
> >> The refcounting solution implemented here is adapted from the one used in
> >> the CPU hotplug infrastructure (kernel/cpu.c). If this patchset sounds
> >> reasonable, I plan to make the refcounting generic (in a later patch) and
> >> expose it via include/linux/refcount.h or something similar, and then
> >> use it
> >> at these 2 places instead of duplicating code.
> >>
> > 
> > IMHO it seems that the write path of the cpu_hotplug is protected by
> > another mutex (cpu_add_remove_lock) to guarantee that the only one
> > writer is active at a time. But I'm not sure this is the case for the
> > umhelper too.
> 
> 
> For the umhelper, I had not added anything explicit for this serialization
> because, all the users of usermodehelper_disable/enable are callers
> from hibernate/suspend code (which all take the 'pm_mutex' lock before
> doing anything) or from reboot/shutdown code.
> 

OK.


> > 
> > If more than 2 tasks call umh_control_begin() at the same time (is it
> > possible though?), it will lost tasks except for the winner and
> > active_writer AFAICS. Am I missing something?
> > 
> 
> 
> See my thoughts above about the callers of umh_control_begin(). 
> 
> Anyways, I'll use rwsemaphores as Tejun suggested, since that would be
> the most logical choice here, and it also makes the code much simpler.
> 
> Thanks a lot for your review!
> 

Yeah, I think the rwsem would be more reasonable, too.


> [Btw I was wondering why your mail didn't land in my inbox. Now I see,
> I am neither in your "To" or "Cc" list! :-)]
> 

My email client was screwed up at that time, maybe due to stupid
security stuff in my company :(

Thanks.


-- 
Regards,
Namhyung Kim


