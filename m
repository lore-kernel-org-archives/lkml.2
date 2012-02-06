Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2BFFzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 00:55:35 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:40529 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769Ab2BFFze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 00:55:34 -0500
Message-ID: <4F2F6B40.6070308@st.com>
Date: Mon, 6 Feb 2012 11:25:12 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>, <len.brown@intel.com>
Cc: "linux-pm@lists.linux-foundation.org" 
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
Subject: Query: When will drv->poweroff() called
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Guys,

Sorry for asking this silly question, but i couldn't locate much
help for it in documentation, so asking it.

We were testing hibernation for SPEAr13xx SoC family, based on
ARM Cortex a9.

I observed that poweroff() callback of individual drivers are not
getting called at all, while we test hibernate.

I tried to go through the code to see what happened. It looked like
there should be call to hibernation_set_ops() for platforms that are
willing to get a call to poweroff() for their drivers. Otherwise
shutdown of the busses gets called, which is a completely different path.

There are many drivers today, that are registering poweroff() from dev_pm_ops
but are not doing bus specific shutdown stuff.

Even i tried to look for hibernation_set_ops() in kernel, and only acpi
code is calling it. I didn't understood how other ARM Sub-Arch's are handling
this.

Thanks in advance :)

-- 
viresh
