Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab2KBIy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 04:54:26 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51169 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab2KBIyV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 04:54:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
References: <1351816703-8805-1-git-send-email-gaofeng@cn.fujitsu.com>
	<87ehkcij1a.fsf@xmission.com> <5093773B.5010706@cn.fujitsu.com>
Date: Fri, 02 Nov 2012 01:54:14 -0700
In-Reply-To: <5093773B.5010706@cn.fujitsu.com> (Gao feng's message of "Fri, 02
	Nov 2012 15:33:15 +0800")
Message-ID: <87wqy4fkqx.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1+UAX7MWmKysIlr/9WDGDa6OHuypRredDU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0039]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gao feng <gaofeng@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] namespace:unmount pid_namespace's proc_mnt when copy_net_ns failed
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gao feng <gaofeng@cn.fujitsu.com> writes:

> 于 2012年11月02日 15:02, Eric W. Biederman 写道:
>> Gao feng <gaofeng@cn.fujitsu.com> writes:
>> 
>>> we should call pid_ns_release_proc to unmount pid_namespace's
>>> proc_mnt when copy_net_ns failed in function create_new_namespaces.
>>>
>>> otherwise,the proc_mnt will not be freed and because the super_block
>>> of proc_mnt also add the reference of the pid_namespace,so this
>>> pid_namespace will never be released too.
>> 
>> Ouch!
>> 
>> Have you encountered this failure in practice or is this just from
>> review?
>
> I add some printk in pid_ns_release_proc,it's not called in above case.
> when copy_net_ns failed,this pid_namespace is not used by any task,
> so proc_flush_task can't call pid_ns_release_proc to umount this pidns->proc_mnt.
> it's the only chance we can unmount this pindns->proc_mnt.
>
> With this patch,everything runs well.

I have reviewed the code and I don't doubt that this is necessary.

What caused you to look into this failure?  Is there some semi-practical
real world case that someone is hitting?

Eric
