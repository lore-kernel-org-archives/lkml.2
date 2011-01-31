Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1AaL0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:26:45 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45937 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab1AaL0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:26:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lm3rnmY2ofGQD9LN3cJeaaoGqBYNYjkxrdFgU1grmAuhqYhsBwMsbkBJxDkcXrLF43
         D7do7tULqoP9Ah7gzxG4foz7qQi4MHQsR0v+xpFDXjb6DCm6j1b1IDV4xsg348zype9C
         hOrjbxxNcDUdv4vStHh3LrFJFxvqTlbTF1XSI=
MIME-Version: 1.0
In-Reply-To: <1296469525-30111-5-git-send-email-daniel.lezcano@free.fr>
References: <1296469525-30111-1-git-send-email-daniel.lezcano@free.fr>
	<1296469525-30111-5-git-send-email-daniel.lezcano@free.fr>
Date: Mon, 31 Jan 2011 13:26:42 +0200
Message-ID: <AANLkTikjcou-0b4NejpY66qXeZuzsC-M+oNTyHk=OE-Z@mail.gmail.com>
Subject: Re: [PATCH 4/4] pidns: Use task_active_pid_ns where appropriate
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, ebiederm@xmission.com, oleg@redhat.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        clg@fr.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 12:25 PM, Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> The expressions tsk->nsproxy->pid_ns and task_active_pid_ns
> aka ns_of_pid(task_pid(tsk)) should have the same number of
> cache line misses with the practical difference that
> ns_of_pid(task_pid(tsk)) is released later in a processes life.
>
> Furthermore by using task_active_pid_ns it becomes trivial
> to write an unshare implementation for the the pid namespace.
>
> So I have used task_active_pid_ns everywhere I can.

Yet current->nsproxy->pid_ns is way clearer.
Because live current always has pid_ns.

This task_active_pid_ns() is misnamed(?) because it does matter only
for dead tasks?

> -               current->nsproxy->pid_ns->last_pid);
> +               task_active_pid_ns(current)->last_pid);

I thought of doing exactly opposite patch :-)
