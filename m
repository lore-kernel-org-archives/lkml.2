Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0FCGCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:02:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33586 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab0FCGCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:02:35 -0400
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       ebiederm@aristanetworks.com, randy.dunlap@oracle.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <201006030523.o535NA16029042@www262.sakura.ne.jp>
	<1275543101.29413.76.camel@edumazet-laptop>
	<20100603055515.GA5580@cr0.nay.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 02 Jun 2010 23:02:28 -0700
In-Reply-To: <20100603055515.GA5580@cr0.nay.redhat.com> (=?utf-8?Q?=22Am?=
 =?utf-8?Q?=C3=A9rico?= Wang"'s message of "Thu\, 3 Jun 2010 13\:55\:15
 +0800")
Message-ID: <m1y6ewr6vf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org, gregkh@suse.de, randy.dunlap@oracle.com, ebiederm@aristanetworks.com, penguin-kernel@I-love.SAKURA.ne.jp, eric.dumazet@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Am=c3=a9rico Wang <xiyou.wangcong@gmail.com>?=
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] kobject: Suppress compiler warning with gcc 3.x
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Thu, Jun 03, 2010 at 07:31:41AM +0200, Eric Dumazet wrote:
>>Le jeudi 03 juin 2010 à 14:23 +0900, Tetsuo Handa a écrit :
>>> Gcc 3.x generates a warning
>>> 
>>>   include/linux/sysfs.h:183: warning: parameter has incomplete type
>>> 
>>> on each file.
>>> Suppress the warning by moving the definition of "enum kobj_ns_type"
>>> to before "#include <linux/sysfs.h>".
>>> 
>>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>
>>
>>I was about to submit same patch, but I was also reverting 27eabc7cb4b3
>>(sysfs: Don't use enums in inline function declaration.)
>>
>>So that sysfs_exit_ns() prototype is consistent regardless of
>>CONFIG_SYSFS
>>
>>What do you think ?
>>
>
> This looks odd, in sysfs.h we do have a forward declaration of
> enum kobj_ns_type... I am wondering why gcc 3.x doesn't recognize it.

Because the replacement is an inline, and we are passing the enum by value
gcc wants to see the full definition, at the point where the inline function
is declared.


Eric
