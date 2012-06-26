Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab2FZIkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:40:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:58331 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab2FZIkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:40:12 -0400
Message-ID: <1340700008.21991.35.camel@twins>
Subject: Re: [PATCH] sched: fix fork() error path to not crash.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Jun 2012 10:40:08 +0200
In-Reply-To: <20120626011815.11323.5533.stgit@dungbeetle.mtv.corp.google.com>
References: <20120626011815.11323.5533.stgit@dungbeetle.mtv.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 18:18 -0700, Salman Qazi wrote:
> In dup_task_struct, if arch_dup_task_struct fails, the clean up
> code fails to clean up correctly.  That's because the clean up
> code depends on unininitalized ti->task pointer.  We fix this
> by making sure that the task and thread_info know about each other
> before we attempt to take the error path.
> 
> Signed-off-by: Salman Qazi <sqazi@google.com>

Cute, however did you find that?
