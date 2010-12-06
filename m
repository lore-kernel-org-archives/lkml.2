Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0LFPxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:53:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0LFPxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:53:53 -0500
Subject: Re: [PATCH] add additional audit info (read/write length & rng
 name) for RNG devices
From: Eric Paris <eparis@redhat.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <1291649535.3065.2088.camel@calx>
References: <20101206152121.GA13235@hmsreliant.think-freely.org>
	 <1291649535.3065.2088.camel@calx>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 10:53:38 -0500
Message-ID: <1291650818.4929.89.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 09:32 -0600, Matt Mackall wrote:
> On Mon, 2010-12-06 at 10:21 -0500, Neil Horman wrote:

+int __audit_rng(const char *name, size_t len)
+{
+       struct audit_aux_data_rng *ax;
+       struct audit_context *context = current->audit_context;
[snip]
+       ax->d.next = context->aux;
+       context->aux = (void *)ax;
+       return 0;
+}


> > +	context->aux = (void *)ax;
> 
> Redundant cast to void *?

It's not redundant.  ax is struct audit_aux_data_rng where the first
entry in the struct is a struct audit_aux_data.  context->aux is a
struct audit_aux_data.  The 'best' thing to do would really be to do
something like:

context->aux = &(ax->d);

Second best would be:

context->aux = (struct audit_aux_data *)ax;

Third best would be what we have.  But since the rest of the aux
structures in the audit code do it this way we do it this way for
consistency.  If we ever fix the rest to do it like the 'best' example
we'll update this one, but I'd rather have consistency that have only
this 'one' be 'more correct'

-Eric

