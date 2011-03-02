Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1CBLHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:07:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48958 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab1CBLHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TycGtPKcADvfO9Wy3p1ZpWq6uI7pbYRu815crHndR7UZdVpv1iEojRKzJPAhAXnLUw
         g++h7z3uEnm2sZRrqfOHeC7djyQP0nakbyLBiMio6qhJd9yvemkoP4/NOyqEqAPb7RsO
         T35qskqkEYS84VcOjiKwWgkaaqjP4UKZ9SGug=
MIME-Version: 1.0
In-Reply-To: <20110302073236.GC19669@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org> <AANLkTinpVJAsUW83Wu3GNqTzXk=QEamJ=G3N-nrJjJhO@mail.gmail.com>
 <20110302073236.GC19669@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Mar 2011 12:02:37 +0100
Message-ID: <AANLkTikyU27CtRgWW4pbdqL9jVYevazTW-t0XBFJ-EeC@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 8:32 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Mar 01, 2011 at 11:59:02PM +0100, Denys Vlasenko wrote:
>> We also have magic SIGSTOPs (magic in a sense they aren't
>> real signals sent by other processes):
>> * at PTRACE_ATTACH
>> * in child (if PTRACE_O_TRACE[V]FORK or PTRACE_O_TRACECLONE opt is on)
>>
>> For example, flagging PTRACE_ATTACH SIGSTOP so that it can be
>> uniquely identified would solve some problems gdb is having with it.
>
> This, I don't agree with.  All we need is a better attach call without
> the implied SIGSTOP, there's no reason to diddle with PTRACE_ATTACH
> further.

Sure.

What do you think about SIGSTOP generated in in children on auto-attach
via PTRACE_O_TRACE[V]FORK / PTRACE_O_TRACECLONE options?

IMHO, it would be good if we'd have a way to distinguish them from
real SIGSTOP signals.

-- 
vda
