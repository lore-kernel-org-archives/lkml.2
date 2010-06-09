Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab0FIQAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:00:55 -0400
Received: from ist.d-labs.de ([213.239.218.44]:54429 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab0FIQAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:00:53 -0400
Date: Wed, 9 Jun 2010 18:00:33 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: pm list <linux-pm@lists.linux-foundation.org>, markgross@thegnar.org,
       mgross@linux.intel.com, linville@tuxdriver.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] pm_qos: make update_request non blocking
Message-ID: <20100609180033.39d5b499@schatten.dmk.lab>
In-Reply-To: <1276097832.4343.223.camel@mulgrave.site>
References: <1276097381-3982-1-git-send-email-florian@mickler.org>
	<1276097832.4343.223.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jun 2010 11:37:12 -0400
James Bottomley <James.Bottomley@suse.de> wrote:


> This still isn't resilient against two successive calls to update.  If
> the second one gets to schedule_work() before the work of the first one
> has finished, you'll corrupt the workqueue.

Sorry, I don't see it. Can you elaborate?

In "run_workqueue(" we do a list_del_init() which resets the
list-pointers of the workitem and only after that reset the
WORK_STRUCT_PENDING member of said structure. 


schedule_work does a queue_work_on which does a test_and_set_bit on
the WORK_STRUCT_PENDING member of the work and only queues the work
via list_add_tail in insert_work afterwards.

Where is my think'o? Or was this fixed while you didn't look?

So what _can_ happen, is that we miss a new notfication while the old
notification is still in the queue. But I don't think this is a problem.

Cheers,
Flo
