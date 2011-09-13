Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1IMIEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 04:04:51 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:36475 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1IMIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 04:04:48 -0400
Message-ID: <9b86bd67bedfcd3d4e592a419d190b90.squirrel@webmail.greenhost.nl>
In-Reply-To: <201109101312.39256.pedro@codesourcery.com>
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
    <201109101219.30942.pedro@codesourcery.com>
    <201109101340.16506.vda.linux@googlemail.com>
    <201109101312.39256.pedro@codesourcery.com>
Date: Tue, 13 Sep 2011 10:04:46 +0200
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in
 'data'
From: "Indan Zupancic" <indan@nul.nu>
To: "Pedro Alves" <pedro@codesourcery.com>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 4052b6d1c9976086d5ab5ce040fcf5b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, September 10, 2011 14:12, Pedro Alves wrote:
>
> I happen to know gdb's code quite well.  ;-)

In that case, could you explain why gdb isn't using WCONTINUED
notifications for selective thread wakeup instead of trying to
achieve the same at group stop time?

Background thread: https://lkml.org/lkml/2011/9/7/294

Basically the only argument against making ptrace not automatically
continue group stopped tasks was that gdb uses that to resume one
thread instead of all. But it does this by letting the tasks hang in
trapped state at group stop notification time, breaking normal group
stops. If it would instead use the group continuation notification,
gdb would never need to directly interfere with group stops.

I find PTRACE_LISTEN an ugly solution to this problem and am searching
for something nicer.

Greetings,

Indan


