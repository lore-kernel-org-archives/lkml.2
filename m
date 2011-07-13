Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab1GMRox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 13:44:53 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51994 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805Ab1GMRow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 13:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfuBxwuVMGSaGmbT02LrwfufHXO_gA-POvr1e7TQ4LYCtkcrA@mail.gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com> <1310370416-6322-4-git-send-email-jim.cromie@gmail.com>
 <CAO+b5-pXKeQ8zk367M4FNG5r6vUm6dOVBcNRaoJr+4i=kOy35A@mail.gmail.com> <CAJfuBxwuVMGSaGmbT02LrwfufHXO_gA-POvr1e7TQ4LYCtkcrA@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 13 Jul 2011 19:44:31 +0200
X-Google-Sender-Auth: El-tvKGNzxKeUJhBnUKAPG5_51s
Message-ID: <CAO+b5-rKYoHnvi49pxoG1YoAumfSB2gQYwBvFn3dT0FPy2OmPg@mail.gmail.com>
Subject: Re: [PATCH 03/21] dynamic_debug: process multiple commands on a line
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 9:25 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> On Mon, Jul 11, 2011 at 11:54 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> > On Mon, Jul 11, 2011 at 9:46 AM, Jim Cromie <jim.cromie@gmail.com> wrote:
> >> Process multiple commands per line, separated by ';'.  All commands are
> >> processed, independent of errors, allowing individual commands to fail,
> >> for example when a module is not installed.  Last error code is returned.
> >> With this, extensive command sets can be given on the boot-line.
> >
> > Does the above mean that semicolon is considered a valid separator but
> > newline not ?
>
> no, your printf example still works.
> Note that it actually issues 2 writes to the control-file.
>
> root@voyage:~# echo 1 > /sys/module/dynamic_debug/parameters/verbose
> trol voyage:~# printf "module foo +ap\n module bar +ap" >
> /dbg/dynamic_debug/cont
>
> FWIW, the \n approach doesnt help on the boot-line;
> on mainline, the following will break the facility -
> /dbg/dynamic_debug will not get created.
>
> Kernel command line: ...  ddebug_query="module pc8736x_gpio +p \n
> module nsc_gpio +p "

Just as a note, I do not expect that anyone will pass a string
containing an embedded newline via the kernel command line but I do
expect that people will use cat or printf to send multiple queries at
once to /sys/kernel/debug/dynamic_debug/control.

Bart.
