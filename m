Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab0FTImx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 04:42:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59821 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab0FTImt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 04:42:49 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com>
	<20100617212003.GA4182@redhat.com>
	<20100618082033.GD16877@hawkmoon.kerlabs.com>
	<20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com>
	<20100618173320.GG16877@hawkmoon.kerlabs.com>
	<20100618175541.GA13680@redhat.com>
	<20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 20 Jun 2010 01:42:37 -0700
In-Reply-To: <20100619190840.GA3424@redhat.com> (Oleg Nesterov's message of "Sat\, 19 Jun 2010 21\:08\:40 +0200")
Message-ID: <m1pqzmqema.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: oleg@redhat.com, dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, xemul@openvz.org, louis.rilling@kerlabs.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 0; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: ; sa07 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: _RELAYCOUNTRY_
Subject: [PATCH 0/6] Unshare support for the pid namespace.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 06/18, Oleg Nesterov wrote:
>>
>> I only try to discuss the idea to break the circular reference.
>
> I don't know what I have missed, but this looks really right to me.
> Besides, we have yet another problem: proc_flush_task()->mntput()
> is just wrong. Consider the multithreaded execing init.
>
> I am going to simplify, test, and send the fix which moves mntput()
> into free_pid_ns() paths.

free_pid_ns is comparatively late, to release the kern_mount.

> But first of all I think we should cleanup the pid_ns_prepare_proc()
> logic. Imho, this code is really ugly. Please see the patches.

Since I have a patchset that makes it possible to unshare the pid
namespace about ready to send I figure we should combine the two
efforts.

This patchset is a prerequisite to my patches for giving namespaces
file descriptors and allowing you to join and existing namespace.
When I look over my old notes it appears there Daniel managed to hit
this proc_mnt reference counting in that context.  So that is definitely
interesting.

Oleg take a look I think I have combined the best of our two patchsets.

Eric
