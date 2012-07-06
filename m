Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2GFSk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:40:58 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:39953 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab2GFSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:40:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: dilip.daya@hp.com
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1340900320.3441.88.camel@pro6455b.example.com>
	<20120705220749.GA11255@mail.hallyn.com> <87ehopu3e5.fsf@xmission.com>
	<1341597680.2829.22.camel@pro6455b.example.com>
Date: Fri, 06 Jul 2012 11:40:45 -0700
In-Reply-To: <1341597680.2829.22.camel@pro6455b.example.com> (Dilip Daya's
	message of "Fri, 06 Jul 2012 14:01:20 -0400")
Message-ID: <87pq88g2c2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX191s2yWfs0a/4h1cW8tSaqj4UjxglByb+U=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1995]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;dilip.daya@hp.com
X-Spam-Relay-Country: 
Subject: Re: Network namespace and bonding WARNING at fs/proc/generic.c remove_proc_entry
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dilip Daya <dilip.daya@hp.com> writes:

> Hi Eric,

> We do need to move bonds between namespaces - because we require
> physical interfaces in each namespace -- we don't want the overheads of
> virtual interfaces, don't have the management infrastructure, and don't
> want to manufacture fake mac addresses that would be required for
> macvlan interfaces.   Since the bonds are implicitly created in the host
> namespace, the only way we know to get bonds directly into the
> namespaces is to move them.

There about 3 ways to create bonding devices.  One of those ways
is to create bonding devices when loading the module.  Another
way is to create a bond device with "echo '+bond35 > /sys/class/net/bonding_masters".
them when loading the module, and my favorite is the standard way
"ip link add type bond".  All but loading the bonding device work in the
network namespace you are in at the type.

> Would "NETDEV_UNREGISTER and NETDEV_REGISTER events to remove/add the
> per device proc files at the appropriate time." help in the case?

Yes.  But since you can create the bonding device in the network
namespace you need it in, I don't see the point, of adding a code
path no one will test for 3 years at a time.

It seems easier to me to just not allow migration of bonding devices
and set peoples expectations a little lower.  Especially given
the very complex user space interfaces.

On ther other hand if you want to write and test and generally own the
patch I will review it.

Eric

