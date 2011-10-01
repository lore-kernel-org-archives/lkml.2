Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab1JAVyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 17:54:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56044 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1JAVyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 17:54:01 -0400
MIME-Version: 1.0
Date: Sat, 1 Oct 2011 23:54:01 +0200
Message-ID: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
Subject: Re: taskstats root only breaking iotop
From: Guillaume Chazarain <guichaz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 2:32 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>      Make TASKSTATS require root access
>      Make taskstats round statistics down to nearest 1k bytes/events

Hello, iotop author here.

With taskstats being root only, what's the benefit of making the stats
imprecise (not that it matters to iotop)?

How about this plan instead:
- byte level stats only if ptrace_may_access() though iotop can
certainly live with 1k rounded values
- rounded stats or just nothing otherwise
- potentially an extra field in the taskstats structure indicating
when the information is degraded

Thanks

-- 
Guillaume
