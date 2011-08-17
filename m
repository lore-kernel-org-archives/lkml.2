Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1HQQDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:03:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56365 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab1HQQDr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:03:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP10A4rcQLht--h1d3PJE=oOrm=MSjGXTUSKVF+ssnkt_gw@mail.gmail.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
 <20110817115543.GA8745@redhat.com> <20110817130531.GA12204@redhat.com> <CAPXgP10A4rcQLht--h1d3PJE=oOrm=MSjGXTUSKVF+ssnkt_gw@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 17 Aug 2011 18:03:26 +0200
Message-ID: <CAK1hOcObOmC-rfAZY6sUX98VZZpDn6+6XrUDJ_nFFGHROEYniQ@mail.gmail.com>
Subject: Re: + prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
 .patch added to -mm tree
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, lennart@poettering.net,
        linux-man@vger.kernel.org, roland@hack.frob.com,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 3:21 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Wed, Aug 17, 2011 at 15:05, Oleg Nesterov <oleg@redhat.com> wrote:
>> On 08/17, Oleg Nesterov wrote:
>>> On 08/16, Andrew Morton wrote:
>>> > From: Lennart Poettering <lennart@poettering.net>
>>> >
>>> > Userspace service managers/supervisors need to track their started
>>> > services.  Many services daemonize by double-forking and get implicitely
>>> > re-parented to PID 1.  The process manager will no longer be able to
>>> > receive the SIGCHLD signals for them.
>>> >
>>> > With this prctl, a service manager can mark itself as a sort of 'sub-init'
>>> > process, able to stay as the parent process for all processes created by
>>> > the started services.  All SIGCHLD signals will be delivered to the
>>> > service manager.
>>>
>>> I try to never argue with the new features. But to be honest, this
>>> doesn't look very good to me.
>>>
>>> OK, a service manager M does prctl(PR_SET_CHILD_REAPER), then it forks
>>> a service X which forks another child C and exits. Then C exits and
>>> notifies M.
>>>
>>> But. How can M know that the service X should be restarted? It only
>>> knows the pid. What if wait(WEXITED) succeeds because C in turn does
>>> fork + exit? What M has 2 or more services?
>>
>> Also. I am almost sure I have already reviewed a very similar patch
>> a long ago.
>
> It's almost the same.
>
>> Ungortunately, I can't find the previous discussion, and
>> I can't recall why that patch was not accepted.
>
> We've just been busy with other things. But now that systemd will not
> only be PID 1 but also the process parent for every user logged into
> the system, we need this functionality.

Getty and login worked rather well for 40+ years.
You need to stop trying to supplant every traditional Unix utility
with systemd. This is becoming ridiculous.
You have is a hammer, everything looks like a nail to you.
Where will you stop?

-- 
vda
