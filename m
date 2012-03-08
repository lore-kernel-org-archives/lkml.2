Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2CHVjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:39:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46925 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CHVju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:39:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Masami Ichikawa <masami256@gmail.com>, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
References: <1329777830-2942-1-git-send-email-masami256@gmail.com>
	<m11up2zu03.fsf@fess.ebiederm.org> <20120308211406.GA24445@kroah.com>
Date: Thu, 08 Mar 2012 13:43:09 -0800
In-Reply-To: <20120308211406.GA24445@kroah.com> (Greg KH's message of "Thu, 8
	Mar 2012 13:14:06 -0800")
Message-ID: <m1aa3qwyz6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18ObGFc/N/oCdaB0HO+9ZtyadDfMHhH64E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0077]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] Fix memory leak in sysfs_sd_setsecdata().
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Thu, Mar 08, 2012 at 01:02:20PM -0800, Eric W. Biederman wrote:
>> Masami Ichikawa <masami256@gmail.com> writes:
>> 
>> > This patch fixies follwing two memory leak patterns that reported by kmemleak.
>> > sysfs_sd_setsecdata() is called during sys_lsetxattr() operation.
>> > It checks sd->s_iattr is NULL or not. Then if it is NULL, it calls
>> > sysfs_init_inode_attrs() to allocate memory.
>> > That code is this.
>> 
>> I don't know how you count two memory leaks.  But there is definitely a
>> leak here sd->s_iattr is allocated and then never assigned.  It looks
>> like I introduced that leak when I re-factored the code to protect
>> the code with sysfs_mutex at the end of 2009.
>> 
>> I am surprise the securlity label crowd has not been screaming about
>> selinux protection not working on sysfs for the last two years.
>> 
>> I have reviewed the code and the fix looks obvious and correct.
>> 
>> Greg can you pick this up?
>
> I applied it a while ago to my tree already :)

Odd I didn't see it linux-next when I looked an hour or so ago.

As long as it is there and it makes it to stable.

Eric

