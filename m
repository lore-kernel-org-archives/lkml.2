Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2GFJvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:51:46 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54596 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2GFJvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:51:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Serge Hallyn <serge.hallyn@canonical.com>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1341565747-15374-1-git-send-email-glommer@parallels.com>
	<87hatli62r.fsf@xmission.com> <4FF6B37B.4040005@parallels.com>
Date: Fri, 06 Jul 2012 02:51:02 -0700
In-Reply-To: <4FF6B37B.4040005@parallels.com> (Glauber Costa's message of
	"Fri, 6 Jul 2012 13:44:27 +0400")
Message-ID: <874npli5fd.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19o4Pf3T/YR4VvkeSU2N9pvnyTohTC4oDg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Glauber Costa <glommer@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] fail dentry revalidation after namespace change
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <glommer@parallels.com> writes:

> On 07/06/2012 01:37 PM, Eric W. Biederman wrote:
>> Glauber Costa <glommer@parallels.com> writes:
>> 
>>> When we change the namespace tag of a sysfs entry, the associated dentry
>>> is still kept around. readdir() will work correctly and not display the
>>> old entries, but open() will still succeed, so will reads and writes.
>> 
>> Note reads and writes of file handles open before the move should
>> continue to work.
>
> Well, yes. But do you see it as a big problem?
>
> This can probably be fixed as well, but I foresee a big hackishness in
> the way =p

At the moment it looks like a feature.

The only reason we bounce between different instances of sysfs is
because of the unfortunate sysfs directory layout that we need
to remain compatible with.

But I don't see it making much of a difference either way.

Eric

