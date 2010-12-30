Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0L3KuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 05:50:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41436 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab0L3KuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 05:50:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rabin Vincent <rabin@rab.in>
Subject: Re: i2c runtime suspend and system wide suspend
Date: Thu, 30 Dec 2010 11:49:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean Delvare <khali@linux-fr.org>, Rajendra Nayak <rnayak@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Vishwanath BS <vishwanath.bs@ti.com>, Partha Basak <p-basak2@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org
References: <4D1C0CFE.5010008@codeaurora.org> <AANLkTinqqgNwgFCMVL-2T83zKnNLGLF007atJ4-EDEW5@mail.gmail.com>
In-Reply-To: <AANLkTinqqgNwgFCMVL-2T83zKnNLGLF007atJ4-EDEW5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301149.30888.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 30, 2010, Rabin Vincent wrote:
> On Thu, Dec 30, 2010 at 10:09 AM, Abhijeet Dharmapurikar
> <adharmap@codeaurora.org> wrote:
> > The i2c-core driver mixes runtime suspend and system wide suspend, in that,
> > during a system wide suspend, it skips calling ->suspend if the device is
> > runtime suspended.
> >
> > I have an interrupt controller running over the i2c bus and that driver is
> > oblivious of the runtime pm framework, IOW, it doesn't do any runtime pm
> > calls. CONFIG_RUNTIME_PM is enabled however (for some other bus drivers).
> > The issue I am facing is that all such i2c devices are assumed runtime
> > suspended and the ->suspend for these devices is not invoked during
> > systemwide suspend.
> 
> This was discussed on linux-pm recently.  Rafael had a fix, I'm don't know
> whether it's applied yet:
> 
> https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029567.html
> https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029596.html

Yes, the fix is already in the Linus' tree:

f08f5a0 PM / Runtime: Fix pm_runtime_suspended()
 
> Also relevant:
> 
> https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029600.html
> https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029658.html

I'm not sure what happened to the last patch.  Is there a new version?
If so, is it going to be pushed through the i2c tree, or should I take it?

Rafael
