Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab1JKGy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 02:54:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46623 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1JKGyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 02:54:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Matt Helsley <matthltc@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, Linux Containers <containers@lists.osdl.org>,
        Linux Containers <lxc-devel@lists.sourceforge.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
References: <1317943022.1095.25.camel@mop>
	<20111007074904.GC16723@count0.beaverton.ibm.com>
	<20111007160113.GB14201@tango.0pointer.de>
	<m17h4g2jqy.fsf@fess.ebiederm.org>
	<20111010163140.GA22191@tango.0pointer.de>
	<m1mxd8lg0x.fsf_-_@fess.ebiederm.org>
	<20111010214148.GB26510@tango.0pointer.de>
Date: Mon, 10 Oct 2011 23:54:39 -0700
In-Reply-To: <20111010214148.GB26510@tango.0pointer.de> (Lennart Poettering's
	message of "Mon, 10 Oct 2011 23:41:48 +0200")
Message-ID: <m1lisshvbk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/HMira62DsRl6Sqsg/nSl45KZYvHW/hxU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 XM_URI_RBL_RM URI removed in uri.bl.xmission.com
	*      [URIs: freedesktop.org]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lennart Poettering <mzxreary@0pointer.de>
X-Spam-Relay-Country: **
Subject: Re: Detecting if you are running in a container
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Poettering <mzxreary@0pointer.de> writes:

> On Mon, 10.10.11 13:59, Eric W. Biederman (ebiederm@xmission.com) wrote:

>> My list of things that still have work left to do looks like:
>> - cgroups.  It is not safe to create a new hierarchies with groups
>>   that are in existing hierarchies.  So cgroups don't work.
>
> Well, for systemd they actually work quite fine since systemd will
> always place its own cgroups below the cgroup it is started in. cgroups
> hence make these things nicely stackable.
>
> In fact, most folks involved in cgroups userspace have agreed to these
> rules now:
>
> http://www.freedesktop.org/wiki/Software/systemd/PaxControlGroups

Wow.   Are cgroups really that complicated to use?  A list of rules
a page long on what you have to do to make them useful and non-conflict.
Something seems off.  Perhaps we need a rule don't mount multiple
controllers in the same hierarchy.

Eric
