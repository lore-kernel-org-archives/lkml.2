Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2FZXbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:31:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2FZXbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:31:50 -0400
Date: Tue, 26 Jun 2012 16:31:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        Greg KH <greg@kroah.com>, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH -v4 6/6] fault-injection: add notifier error injection
 testing scripts
Message-Id: <20120626163147.93181e21.akpm@linux-foundation.org>
In-Reply-To: <1340463502-15341-7-git-send-email-akinobu.mita@gmail.com>
References: <1340463502-15341-1-git-send-email-akinobu.mita@gmail.com>
	<1340463502-15341-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2012 23:58:22 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This adds two testing scripts with notifier error injection

Can we move these into tools/testing/selftests/, so that a "make
run_tests" runs these tests?

Also, I don't think it's appropriate that "fault-injection" be in the
path - that's an implementation detail.  What we're testing here is
memory hotplug, pm, cpu hotplug, etc.  So each test would go into, say,
tools/testing/selftests/cpu-hotplug.

Now, your cpu-hotplug test only tests a tiny part of the cpu-hotplug
code.  But it is a start, and creates the place where additional tests
will be placed in the future.


If the kernel configuration means that the tests cannot be run, the
attempt should succeed so that other tests are not disrupted.  I guess
that printing a warning in this case is useful.

Probably the selftests will require root permissions - we haven't
really thought about that much.  If these tests require root (I assume
they do?) then a sensible approach would be to check for that and to
emit a warning and return "success".

My overall take on the fault-injection code is that there has been a
disappointing amount of uptake: I don't see many developers using them
for whitebox testing their stuff.  I guess this patchset addresses
that, in a way.

