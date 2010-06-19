Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0FSTKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 15:10:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622Ab0FSTKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 15:10:39 -0400
Date: Sat, 19 Jun 2010 21:08:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] pid_ns_prepare_proc/unshare cleanups
Message-ID: <20100619190840.GA3424@redhat.com>
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com> <20100617212003.GA4182@redhat.com> <20100618082033.GD16877@hawkmoon.kerlabs.com> <20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com> <20100618173320.GG16877@hawkmoon.kerlabs.com> <20100618175541.GA13680@redhat.com> <20100618212355.GA29478@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618212355.GA29478@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Oleg Nesterov wrote:
>
> I only try to discuss the idea to break the circular reference.

I don't know what I have missed, but this looks really right to me.
Besides, we have yet another problem: proc_flush_task()->mntput()
is just wrong. Consider the multithreaded execing init.

I am going to simplify, test, and send the fix which moves mntput()
into free_pid_ns() paths.

But first of all I think we should cleanup the pid_ns_prepare_proc()
logic. Imho, this code is really ugly. Please see the patches.

The last one, 4/4, is orthogonal to other changes.

Oleg.

