Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab2FZQ6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:58:44 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:55333 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758433Ab2FZQ6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <1340700008.21991.35.camel@twins>
References: <20120626011815.11323.5533.stgit@dungbeetle.mtv.corp.google.com>
	<1340700008.21991.35.camel@twins>
Date: Tue, 26 Jun 2012 09:58:41 -0700
Message-ID: <CAKUOC8Uy_YeoMW_S_JZbZUr1i_3mJGNfrNs676rc_o28WJGhjA@mail.gmail.com>
Subject: Re: [PATCH] sched: fix fork() error path to not crash.
From: Salman Qazi <sqazi@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 1:40 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-06-25 at 18:18 -0700, Salman Qazi wrote:
>> In dup_task_struct, if arch_dup_task_struct fails, the clean up
>> code fails to clean up correctly.  That's because the clean up
>> code depends on unininitalized ti->task pointer.  We fix this
>> by making sure that the task and thread_info know about each other
>> before we attempt to take the error path.
>>
>> Signed-off-by: Salman Qazi <sqazi@google.com>
>
> Cute, however did you find that?

Our test infrastructure folks have developed a fault injection
framework geared towards detecting bugs triggered by memory allocation
failures in random places.
