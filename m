Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab2LUHrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 02:47:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50015 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2LUHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 02:47:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rob@landley.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
References: <1356073548.24099.26@driftwood>
Date: Thu, 20 Dec 2012 23:47:22 -0800
In-Reply-To: <1356073548.24099.26@driftwood> (Rob Landley's message of "Fri,
	21 Dec 2012 01:05:48 -0600")
Message-ID: <87k3sbonhx.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX188FNNA9CzB3BF7yP790131omlkSCXAU5U=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0021]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rob Landley <rob@landley.net>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] user namespace and namespace infrastructure changes for 3.8
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> writes:

> On 12/17/2012 05:18:57 PM, Eric W. Biederman wrote:
>> Work remains to make it safe to build user namespaces and 9p, afs,
>> ceph, cifs, coda, gfs2, ncpfs, nfs, nfsd, ocfs2, and xfs so the  
>> Kconfig
>> guard remains in place preventing that user namespaces from being  
>> built
>> when any of those filesystems are enabled.
>
> What work specifically?

Essentially the uid_t to kuid_t and gid_t to kgid_t conversion.

These are the more complex filesystems.  And I haven't yet had
the time to go through the preliminary patches in my development branch
and convert them into stupid obviously correct patches, or review them
closely.

The changes generally are pretty simple the amount of review to ensure I
didn't overlook things tends to proprotional to the size of the file
system.

There is also the fact that I don't use most of those file-systems.

The big advantage of finishing those filesystems is that user namespaces
can be turned on in allyesconfig, allowing my compile time checks to
notice when someone doesn't use kuids and kgids.

Eric

