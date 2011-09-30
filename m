Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1I3Qo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:44:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39967 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab1I3Qo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:44:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH 3/3] PM / QoS: Add function dev_pm_qos_read_value() (v2)
Date: Fri, 30 Sep 2011 18:46:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Ming Lei <tom.leiming@gmail.com>
References: <201108310017.03103.rjw@sisk.pl> <201109292233.52378.rjw@sisk.pl> <CAORVsuV4ccJvJg-zCrhVXJKmHkEYLLQh032=BMh7qH27bTK5uQ@mail.gmail.com>
In-Reply-To: <CAORVsuV4ccJvJg-zCrhVXJKmHkEYLLQh032=BMh7qH27bTK5uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109301846.41364.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 30, 2011, Jean Pihet wrote:
> Hi Rafael,
> 
> On Thu, Sep 29, 2011 at 10:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > On Thursday, September 29, 2011, Jean Pihet wrote:
> >> Hi Rafael,
> >>
> >> I have a few minor remarks, inlined below.
> >
> > In the meantime it turned out that the patch caused a build failure
> > for CONFIG_PM_SLEEP unset (your original patches won't really work
> > in this case too), so I posted a patch to fix it.  However, since
> > you had remarks anyway, I've simply folded the fix into the next
> > version of the $subject patch, which is appended.
> OK to me.
> 
> I have 2 remarks though:
> - some drivers are using the power_state field in the suspend/resume
> operation, IIUC without conflict. Can you confirm?

Yes, I can.  There are no conflicts.

> - the power_state field is scheduled for removal, cf.
> Documentation/feature-removal-schedule.txt. That does not look
> correct.

It still is schediled for removal, but we can't remove it right now
anyway because of the users mentioned above.  I'll replace this field
with a one-bit flag when we're ready to drop it (some time in future).

Thanks,
Rafael
