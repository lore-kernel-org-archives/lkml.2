Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab1FBLw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:52:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:50795 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab1FBLw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:52:58 -0400
Subject: Re: [PATCH] sched: fix conflict of schedule domain balance in RT
 scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <BANLkTikoVj42S1iBHU_xFEpuGxY+TqmweA@mail.gmail.com>
References: <BANLkTikoVj42S1iBHU_xFEpuGxY+TqmweA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 13:56:29 +0200
Message-ID: <1307015789.2497.640.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 21:58 +0800, Hillf Danton wrote:
> SD_BALANCE_WAKE and SD_WAKE_AFFINE are defined to be mutually
> exclusive

Uhm, no they're not.. both affect placement of a woken task but they're
complementary. WAKE_AFFINE is a check to see if it makes sense to run
the woken task on the same cpu as the wakee, BALANCE_WAKE does a full
load-balance pass, in case its combined with WAKE_AFFINE it does so in
case that test is negative.



