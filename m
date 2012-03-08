Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2CHVIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:08:53 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:38598 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2CHVIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:08:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: chaitanya g <chaitanyag3.14@gmail.com>
Cc: linux-kernel@vger.kernel.org
References: <CAOvk4sHM0buk8TW1w8n3EgnNHh6r=57RTUQXKNrCeBFcXjQ7Sg@mail.gmail.com>
Date: Thu, 08 Mar 2012 13:12:10 -0800
In-Reply-To: <CAOvk4sHM0buk8TW1w8n3EgnNHh6r=57RTUQXKNrCeBFcXjQ7Sg@mail.gmail.com>
	(chaitanya g.'s message of "Thu, 23 Feb 2012 13:04:09 +0530")
Message-ID: <m1haxyyez9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Bgq+R7OcTwaKtssJja0kY0JKWu729JR0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0064]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;chaitanya g <chaitanyag3.14@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: Linux kernel : sysctl registering table under same proc name (path) gives warning and call trace while unregistering
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chaitanya g <chaitanyag3.14@gmail.com> writes:

> Hello there,
>
> I am creating a sysctl kernel module to register 2 hierarchy under
> same proc name. For e.g.
>
>   my_net
>   |          |
> net1  net2
>  |         |
> t1        t2
>
> So, I used register_sysctl_paths() API. Everything works fine when
> registering the sysctl tables net1 net2 under path name my_net.
>
> Problem is when unregistering the tables dmesg shows kernel tainted
> warning and a call trace.
>
> Here, is pastebin link to the warning message http://pastebin.com/NfLQhikJ
>
> Here is pastebin link to module source http://pastebin.com/jSfPW5Y5

Adding those as attachments or simple inline inclusions would have been
much easier to work with.

> Kindly, please help me to resolve this panic.

Well it wasn't a panic, it was a WARN_ON, and you are running against a
very old kernel.  The .ctl_name field no longer exists.  I guess it says
2.6.32.something.

The only possibility is you have run afoul of the current sysctl rule
that you must create a sysctl path before you add child entries and you
must destroy a sysctl path before you remove child entries.  It is
extremely non-intuitive, and should be fixed in my current sysctl tree.

Eric
