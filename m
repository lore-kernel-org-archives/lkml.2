Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab2DITNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:13:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24729 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab2DITNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:13:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6675"; a="177759393"
X-IronPort-AV: E=Sophos;i="4.75,394,1330934400"; 
   d="scan'208";a="301069176"
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20355.13473.382563.281929@gargle.gargle.HOWL>
Date: Tue, 10 Apr 2012 00:42:33 +0530
To: Michael Leun <lkml20120218@newton.leun.net>
CC: Ben Greear <greearb@candelatech.com>,
        Kelly Anderson <kelly@silka.with-linux.com>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <casteyde.christian@free.fr>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: [ath9k-devel] 3.4-rc ath9k regression (Re: 3.3.1 ath9k regression)
In-Reply-To: <20120409010816.36244f17@xenia.leun.net>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
	<CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
	<4F7A9D5C.8040402@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
	<4F7DE3A4.1040705@candelatech.com>
	<CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
	<4F7F52BD.7060906@candelatech.com>
	<20120409010816.36244f17@xenia.leun.net>
X-Mailer: VM 8.2.0a under 23.4.1 (x86_64-unknown-linux-gnu)
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Leun wrote:
> After an suspend to disk / resume cycle (in kernel suspend to disk,
> openSuSE) with 3.4-rc2 my ath9k wireless does not ping
> anymore.
> 
> Output of iwconfig wlan0 looks just as usual (associated to AP).
> 
> iwconfig wlan0 essid <myssid> fixes this (causes an
> deauthenticate/authenticate with AP) - then connectivity is there again.
> 
> Guess what: "Of course" does not happen when reverting
> c1afdaff90538ef085b756454f12b29575411214 ath9k: fix going to full-sleep
> on PS idle.
> 
> So, in my opinion it should be seriously considered to revert that patch
> until it is fully understood what is going on and why.
> 
> It may look theoretically correct (I've no knowledge that would enable
> me assess that), but it seems to have caused 3 more or less different
> problems to various people.

The patch in question should just be reverted for 3.3.1-stable. It would mean
that power-saving would take a hit on that kernel - but it's impact would be
much lesser than a broken driver, one that fails in basic connection.
I'll send a patch reverting c1afdaff90538ef085b756454f12b29575411214.

For 3.4, can you build the driver with debugging enabled [1] , load the driver
with debug=0x801 and post the log here (before/after resume) ?

Thanks.

[1] : http://linuxwireless.org/en/users/Drivers/ath9k/debug

Sujith
