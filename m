Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1FPNVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1FPNVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:21:14 -0400
Date: Thu, 16 Jun 2011 15:18:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: Louis Rilling <Louis.Rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, containers@lists.osdl.org,
        akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
	Vpid:)
Message-ID: <20110616131821.GA21230@redhat.com>
References: <20110615145527.4016.70157.stgit@bahia.local> <20110615184625.GA15573@redhat.com> <1308222107.8230.49.camel@bahia.local> <20110616123554.GA7230@hawkmoon.kerlabs.com> <1308229251.8230.77.camel@bahia.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308229251.8230.77.camel@bahia.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16, Greg Kurz wrote:
>
> Ok. You're right, the RCU grace period is just what I need to ensure I
> won't dereference a stale pointer. So I don't even have to bother with
> ->siglock and just check pid_alive() before peeking into pid->numbers.

Yes, but you don't really need pid_alive(). Just read ->pids[].pid and
check it is !NULL before dereferencing. Also, we already have 2 pid_alive()
checks, this is ugly. You can consolidate this code.

Oleg.

