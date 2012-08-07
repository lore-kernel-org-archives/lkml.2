Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2HGRRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:17:25 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56545 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2HGRRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:17:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Ariyasu <jan.ariyasu@hp.com>, Jan Ariyasu <jan.ariyasu@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, Thomas Graf <tgraf@infradead.org>,
        Xi Wang <xi.wang@gmail.com>
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
	<87mx27rig7.fsf@xmission.com> <87zk67q31q.fsf_-_@xmission.com>
Date: Tue, 07 Aug 2012 10:17:02 -0700
In-Reply-To: <87zk67q31q.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Mon, 06 Aug 2012 11:38:09 -0700")
Message-ID: <87ipcud3ld.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+vRu5EI8Dr1GuK7Wf4WDl3LAvYvZihBDs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0073]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH net-next 0/7] sctp: network namespace support Part 2: per net tunables
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since I am motivated to get things done, and since there has been much
grumbling about my patches not implementing tunables, I have added
tunable support on top of my last patchset.

I have performed basic testing on the these patches and nothing
appears amis.

The sm statemachine is a major tease as it has all of these association
and endpoint pointers in the common set of function parameters that turn
out to be NULL at the most inconvinient times.  So I added to the common
parameter list a struct net pointer, that is never NULL. 

 include/net/netns/sctp.h   |   96 +++++++-
 include/net/sctp/sctp.h    |   16 +-
 include/net/sctp/sm.h      |    8 +-
 include/net/sctp/structs.h |  126 +---------
 net/sctp/associola.c       |   18 +-
 net/sctp/auth.c            |   20 ++-
 net/sctp/bind_addr.c       |    6 +-
 net/sctp/endpointola.c     |   13 +-
 net/sctp/input.c           |    6 +-
 net/sctp/primitive.c       |    4 +-
 net/sctp/protocol.c        |  137 +++++-----
 net/sctp/sm_make_chunk.c   |   61 +++--
 net/sctp/sm_sideeffect.c   |   26 ++-
 net/sctp/sm_statefuns.c    |  631 ++++++++++++++++++++++++--------------------
 net/sctp/sm_statetable.c   |   17 +-
 net/sctp/socket.c          |   92 ++++---
 net/sctp/sysctl.c          |  200 ++++++++------
 net/sctp/transport.c       |   23 +-
 18 files changed, 817 insertions(+), 683 deletions(-)

Eric W. Biederman (7):
      sctp: Add infrastructure for per net sysctls
      sctp: Push struct net down to sctp_chunk_event_lookup
      sctp: Push struct net down into sctp_transport_init
      sctp: Push struct net down into sctp_in_scope
      sctp: Push struct net down into all of the state machine functions
      sctp: Push struct net down into sctp_verify_ext_param
      sctp: Making sysctl tunables per net

Eric


