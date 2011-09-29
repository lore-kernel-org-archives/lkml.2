Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab1I2QpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 12:45:20 -0400
Received: from claw.goop.org ([74.207.240.146]:42108 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab1I2QpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 12:45:19 -0400
Message-ID: <4E84A09A.2030909@goop.org>
Date: Thu, 29 Sep 2011 09:45:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jan Glauber <jang@linux.vnet.ibm.com>
CC: Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Jump Label initialization
References: <4E83D49C.9080809@goop.org> <1317297894.23938.9.camel@localhost.localdomain>
In-Reply-To: <1317297894.23938.9.camel@localhost.localdomain>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2011 05:04 AM, Jan Glauber wrote:
>
> s390 does not have the early() variant since it didn't need it. On
> pre-SMP we probably don't need stop_machine() so creating
> arch_jump_label_transform_early() by leaving out stop_machine()
> and patching the code directly should be fine.

Well, it occurs to me that if you're using jump_label_enable() very
early, then it will be using the full arch_jump_label_transform()
anyway.  While the stop_machine(), locking, etc that the full version
does is redundant in a pre-SMP environment, it shouldn't hurt, so
perhaps there's no need for an _early variant at all.

    J
