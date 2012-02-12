Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2BLEZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 23:25:10 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37657 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2BLEZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 23:25:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <haveblue@us.ibm.com>,
        linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>,
        St?phane Graber <stgraber@ubuntu.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>
Subject: Re: prevent containers from turning host filesystem readonly
References: <20120211031939.GA4772@sergelap>
	<20120211033732.GK23916@ZenIV.linux.org.uk>
	<20120211040722.GA5891@sergelap> <m1zkcp2np9.fsf@fess.ebiederm.org>
	<20120211202803.GA19961@hallyn.com>
Date: Sat, 11 Feb 2012 20:27:54 -0800
In-Reply-To: <20120211202803.GA19961@hallyn.com> (Serge E. Hallyn's message of
	"Sat, 11 Feb 2012 20:28:03 +0000")
Message-ID: <m1sjig1xrp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19c7FEVgpZXWJXrxcH/CcR7SeTfw7ndWmo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

>> Serge let me respectfully suggest that getting the user namespace done
>> will deal with this issue nicely.
>> 
>> In the simple case you simply won't be root so remount will just be
>> denied.
>> 
>> When/if we allow a limited form of unprivileged mounts in a user
>> namespace your user won't have mounted the filesystem so you should not
>> have the privilege to call remount on the filesystem.
>
> Hm, that's a good point.  Though note it'll require the userns code to
> distinguish between the a bind remount and superblock remount.  The
> last time we seriously discussed this, that wasn't even on the roadmap.
> It was only going to support fully assigning the whole filesystem to
> a user namespace.  In that case, the remount issue doesn't apply anyway
> as the fs isn't shared with another container.

Come to think of it unmounting and remounting is a bit tricky, and
it is a bit parallel to having a disk base filesystem being in one
user namespace.  Currently my patches have the rule that everything
maps to the initial user namespace, so using a filesystem from multiple
user namespaces is not a problem.

Unmounting is pretty safe if the rule is that you control the entire
mount namespace.

Remounting though that does become tricky in the unprivileged situation.
I honestly haven't thought through what that permission check should
look like yet.

Eric

