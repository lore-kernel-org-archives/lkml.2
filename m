Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab0FYQFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 12:05:44 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:58466 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab0FYQFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 12:05:43 -0400
Date: Fri, 25 Jun 2010 11:00:25 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
       anton@samba.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>, Bryan Wu <cooloney@kernel.org>,
       Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
       anton@samba.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 2/5] cpumask: make task_struct.cpus_allowed a
 cpumask_var_t
In-Reply-To: <201006252233.40481.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.1006251058180.18900@router.home>
References: <201006252233.40481.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010, Rusty Russell wrote:

> Even better would be to point to the fixed "one cpu" and "all cpus"
> masks where possible, and make a copy when setting it to something
> else.  But you'd have to track down those naughty places which frob it
> directly...

Put it into a read only segment?

What is the estimated performance impact of adding a level of indirection
(and a potential cache miss) to a number of critical code paths?

