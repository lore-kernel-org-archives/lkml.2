Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab0JZKt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:49:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758963Ab0JZKt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:49:26 -0400
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
In-Reply-To: <4CC68DE1.1060604@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
	 <1271356648-5108-2-git-send-email-glommer@redhat.com>
	 <4CC6130B.8020908@goop.org>  <4CC68DE1.1060604@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat Inc.
Date: Tue, 26 Oct 2010 08:49:22 -0200
Message-ID: <1288090162.3530.0.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 10:14 +0200, Avi Kivity wrote:
> On 10/26/2010 01:30 AM, Jeremy Fitzhardinge wrote:
> > Unfortunately this is breaking Xen save/restore: if you restore on a
> > host which was booted more recently than the save host, causing the
> > system time to be smaller.  The effect is that the domain's time leaps
> > forward to a fixed point, and stays there until the host catches up to
> > the source host...
> 
> Shouldn't save/restore also save the timebase?
> 
> > I guess last_time needs to be reset on this type of event.  I guess the
> > cleanest way would be for pvclock.c to register a sysdev suspend/resume
> > handler.
> 
> Should be for Xen only; kvm save/restore doesn't involve the guest.

the suspend/resume path do adjust the time base. Maybe something similar
should be done ?


