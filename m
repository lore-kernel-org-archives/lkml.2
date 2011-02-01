Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab1BAIon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:44:43 -0500
Received: from mail4.comsite.net ([205.238.176.238]:43056 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1BAIom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 03:44:42 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
In-Reply-To: <4D47D21E020000780002F9FB@vpn.id2.novell.com>
References: <4D47D21E020000780002F9FB@vpn.id2.novell.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: calling smp_call_function_many() with non-stable CPU mask
Date: Tue, 01 Feb 2011 02:44:41 -0600
X-Originating-IP: 71.22.127.106
Message-ID: <1296549881_6450@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are a couple of examples of smp_call_function_many() getting
> called with mm_cpumask() as the first argument. Since that mask
> generally can change while smp_call_function_many() is executing,
> it seems there might be a problem with the case where that mask
> becomes empty after the initial checks, but before the mask is made
> permanent (by copying into data->cpumask).
> 
> Shouldn't there be a check of data->refs being zero right after
> setting it (to avoid having csd_lock_wait() wait for a remote CPU
> to clear the lock flag, and to avoid adding the entry to
> call_function.queue)?
> 
> If that isn't considered necessary, is it then incorrect to pass
> in-flight CPU masks to smp_call_function_many() (and should
> this requirement then be documented somewhere, and the
> existing calls all be inspected for correctness)?
> 

Mike Galbraith just brought this up, and I supplied a patch, and even
a rediff on top of other changes:

http://lkml.indiana.edu/hypermail/linux/kernel/1101.3/02813.html
http://lkml.indiana.edu/hypermail/linux/kernel/1101.3/03172.html

http://lkml.indiana.edu/hypermail/linux/kernel/1102.0/00017.html


This doesn't address https://bugzilla.kernel.org/show_bug.cgi?id=23042 
which is x86 not expecting the mask to be cleared while its thinking
about the mask.

milton
