Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1BUWRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:17:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45208 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1BUWRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:17:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.37.1 s2disk regression (TPM)
Date: Mon, 21 Feb 2011 23:17:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        "linux-pm" <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        debora@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>, preining@logic.at
References: <4D60E93D.1050205@gmail.com> <4D62E221.7010104@linux.vnet.ibm.com> <4D62E2F2.4060406@gmail.com>
In-Reply-To: <4D62E2F2.4060406@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201102212317.07295.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 21, 2011, Jiri Slaby wrote:
> On 02/21/2011 11:07 PM, Rajiv Andrade wrote:
> > On 02/21/2011 06:44 PM, Jiri Slaby wrote:
> >> On 02/21/2011 10:29 PM, Stefan Berger wrote:
> >>> On 02/21/2011 03:39 PM, Jiri Slaby wrote:
> >>>> On 02/21/2011 06:12 PM, Rajiv Andrade wrote:
> >>>>> On 02/21/2011 01:34 PM, Jiri Slaby wrote:
> >>>>>> There has to be another problem which caused my regression. And
> >>>>>> since it
> >>>>>> reports "Operation Timed out", the former default timeout values
> >>>>>> worked
> >>>>>> for me, the ones read from TPM do not.
> >>>>> Yes, it's highly due inconsistent timeout values reported by the
> >>>>> TPM as
> >>>>> I mentioned, my working timeouts are:
> >>>>> 3020000 4510000 181000000
> >>>> 1000000 2000 150000
> >>>>
> >>>> Actually the first one from HW is 1. This is one is HZ after correction
> >>>> in get_timeout. So perhaps it is in ms, yes.
> >>> Following the specs, the timeouts are supposed to be in microseconds and
> >>> ascending order for short, medium and long duration. Of course, if the
> >>> device returns wrong timeouts, the command isn't going to succeed,
> >>> failing the suspend in this case. Nevertheless, I think we need the
> >>> patch I put in but at the same time we'll need a work-around for devices
> >>> like this.
> >> Yes, the patch is correct per se. But as it breaks bunch of machines it
> >> cannot go in now. The rule is no regressions.
> >>
> >> After you have the workaround it should go into the next rc1 after that.
> >> Do you plan to add a dmi-based quirk? Or, IOW do you want me to attach
> >> dmidecode output? Or are you going to base it solely on TPM
> >> manufacturer/version
> > It's more reliable to base the workaround on the values themselves,
> > instead of the TPM's ID, since
> > we don't know whether other models will behave similarly.
> 
> As I wrote, you may base it on dmi data.

In which case this report will have to be taken into account too:
http://marc.info/?l=linux-acpi&m=129796038509311&w=4

Thanks,
Rafael
