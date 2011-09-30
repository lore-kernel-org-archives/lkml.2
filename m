Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab1I3OuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 10:50:04 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:39830 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1I3OuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 10:50:01 -0400
Subject: Re: [PATCH RFC 7/8] s390/jump-label: add
 arch_jump_label_transform_early()
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <b1d87557dc3001031ee8d7f69ee97b90cecba6aa.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
	 <b1d87557dc3001031ee8d7f69ee97b90cecba6aa.1317338254.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 16:48:19 +0200
Message-Id: <1317394099.11297.54.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 16:26 -0700, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> This allows jump-label entries to be modified early, in a pre-SMP
> environment.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: Jan Glauber <jang@linux.vnet.ibm.com>

Hi Jeremy,

Your patch looks fine, if you can fix the minor compiler warnings
below. Excluding stop_machine() on pre-SMP also looks safer too me.

--Jan

  CC      arch/s390/kernel/jump_label.o
arch/s390/kernel/jump_label.c: In function ‘__jump_label_transform’:
arch/s390/kernel/jump_label.c:41:2: error: ‘rc’ undeclared (first use in this function)
arch/s390/kernel/jump_label.c:41:2: note: each undeclared identifier is reported only once for each function it appears in
arch/s390/kernel/jump_label.c:41:2: warning: passing argument 1 of ‘probe_kernel_write’ makes pointer from integer without a cast [enabled by default]
include/linux/uaccess.h:108:21: note: expected ‘void *’ but argument is of type ‘jump_label_t’
arch/s390/kernel/jump_label.c:28:19: warning: unused variable ‘args’ [-Wunused-variable]
make[2]: *** [arch/s390/kernel/jump_label.o] Error 1


