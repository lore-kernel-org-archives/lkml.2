Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab0EEVfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:35:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32798 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0EEVfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:35:12 -0400
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <20100430163538.7253a9e0.sfr@canb.auug.org.au>
	<20100430105016.40b51636.randy.dunlap@oracle.com>
	<20100505091738.7ec27479.randy.dunlap@oracle.com>
	<20100505162459.GA20296@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 May 2010 14:35:03 -0700
In-Reply-To: <20100505162459.GA20296@suse.de> (Greg KH's message of "Wed\, 5 May 2010 09\:24\:59 -0700")
Message-ID: <m1d3xa1188.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: gregkh@suse.de, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, randy.dunlap@oracle.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: linux-next: Tree for April 30 (CONFIG_SYSFS=n)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Wed, May 05, 2010 at 09:17:38AM -0700, Randy Dunlap wrote:
>> On Fri, 30 Apr 2010 10:50:16 -0700 Randy Dunlap wrote:
>> 
>> > On Fri, 30 Apr 2010 16:35:38 +1000 Stephen Rothwell wrote:
>> > 
>> > > Hi all,
>> > > 
>> > > Changes since 20100429:
>> > 
>> > 
>> > When CONFIG_SYSFS is disabled:
>> > 
>> > include/linux/sysfs.h:330: error: parameter 1 ('type') has incomplete type
>> 
>> 
>> Still have this in linux-next of May 5-2010.
>
> Eric, this is due to your changes, care to fix it up?

Apologies for not looking at this earlier.  I just took a look
at this and I believe this error is the result of a gcc bug.


This appears to the fragment that doesn't compile.

enum kobj_ns_type;
static inline void sysfs_exit_ns(enum kobj_ns_type type, const void *tag)
{
}


I could either include kobject.h or make the fragment:
static inline void sysfs_exit_ns(int type, const void *tag)
{
}

I really don't like either option. 

Does anyone know how to smack gcc up the side of the head and convince
it has all of the information it needs, and get it to stop complaining?


Eric
