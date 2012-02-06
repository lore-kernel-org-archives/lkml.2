Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2BFMD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:03:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38879 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2BFMDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:03:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@st.com>
Subject: Re: Query: When will drv->poweroff() called
Date: Mon, 6 Feb 2012 13:07:40 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Vipin KUMAR <vipin.kumar@st.com>, deepak sikri <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <amit.virdi@st.com>, Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>
References: <4F2F6B40.6070308@st.com>
In-Reply-To: <4F2F6B40.6070308@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202061307.40628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, February 06, 2012, Viresh Kumar wrote:
> 
> Hi Guys,
> 
> Sorry for asking this silly question, but i couldn't locate much
> help for it in documentation, so asking it.
> 
> We were testing hibernation for SPEAr13xx SoC family, based on
> ARM Cortex a9.
> 
> I observed that poweroff() callback of individual drivers are not
> getting called at all, while we test hibernate.

They should be called in the last phase of hibernation, after the image
has been created and the system is going for "power off" (hance the
callback name).

> I tried to go through the code to see what happened. It looked like
> there should be call to hibernation_set_ops() for platforms that are
> willing to get a call to poweroff() for their drivers.

That's correct.  The ->poweroff() callbacks are only executed if
hibernation_mode is equal to HIBERNATION_PLATFORM, which is not the
default.

> Otherwise shutdown of the busses gets called, which is a completely
> different path.
> 
> There are many drivers today, that are registering poweroff() from dev_pm_ops
> but are not doing bus specific shutdown stuff.
> 
> Even i tried to look for hibernation_set_ops() in kernel, and only acpi
> code is calling it.

That's correct too.

> I didn't understood how other ARM Sub-Arch's are handling this.

Well, they are supposed to call hibernation_set_ops() and set the operations
appropriately.  Those operations may be empty routines if they don't need
to do anything, but they have to be defined.

Thanks,
Rafael
