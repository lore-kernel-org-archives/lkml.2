Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528Ab0EEAgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:36:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34611 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808Ab0EEAgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:36:12 -0400
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>, <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>
From: ebiederm@xmission.com (Eric W. Biederman)
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
Date: Tue, 04 May 2010 17:35:54 -0700
In-Reply-To: <m1fx3hk6gw.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Tue\, 30 Mar 2010 11\:30\:23 -0700")
Message-ID: <m1d3xb4239.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: gregkh@suse.de, davem@davemloft.net, netdev@vger.kernel.org, serue@us.ibm.com, bcrl@lhnet.ca, eric.dumazet@gmail.com, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com, kay.sievers@vrfy.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [PATCH 0/6] netns support in the kobject layer
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With the tagged sysfs support finally merged into Greg's tree,
it is time for the last little bits of work to get the kobject
layer and network namespaces to play together properly.

These patches are roughly evenly divided between network layer work
and sysfs layer work.  Last time this conundrum came up I believe
we decided that the easiest way to handle this was for Greg to carry
all of the patches.  David, Greg does that still make sense?

This patchset adds:
- kobject layer support for sending events in all network namespaces
- netlink support for filtering broadcast packets based on attributes
  of the destination socket.
- Enabling the network namespace support for sysfs and the kobject layer.

 include/linux/kobject.h  |    1 +
 include/linux/netlink.h  |    4 ++
 lib/kobject_uevent.c     |  108 +++++++++++++++++++++++++++++++++++++++++-----
 net/Kconfig              |    8 +++
 net/core/dev.c           |   28 ++----------
 net/core/net-sysfs.c     |   62 ++++++++++++++++++++------
 net/core/net-sysfs.h     |    1 -
 net/netlink/af_netlink.c |   21 ++++++++-
 8 files changed, 181 insertions(+), 52 deletions(-)
