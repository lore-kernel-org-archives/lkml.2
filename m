Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2ARMpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 07:45:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58068 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2ARMpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 07:45:06 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=qAqWnOW7K_4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=WMQGHCxBd6kvcYGyDNQA:9 a=6EqvEbmhcTZh4zUIdTEA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326890703.17534.76.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 2/4] wait-simple: Simple waitqueue implementation
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Wed, 18 Jan 2012 07:45:03 -0500
In-Reply-To: <1326878928.7482.2.camel@marge.simson.net>
References: <20120118034531.335521323@goodmis.org>
	 <20120118034700.245278561@goodmis.org>
	 <1326878928.7482.2.camel@marge.simson.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 10:28 +0100, Mike Galbraith wrote:
> > +
> > +void __init_swait_head(struct swait_head *head, struct lock_class_key *key)
> > +{
> > +	raw_spin_lock_init(&head->lock);
> > +	lockdep_set_class(&head->lock, key);
> > +	INIT_LIST_HEAD(&head->list);
> > +}
> > +EXPORT_SYMBOL_GPL(__init_swait_head);
> 
> #include <linux/module.h> ?

Did it fail to compile for you?  The 3.2 version included linux/export.h
which didn't exist, and that failed the compile for me. I removed it an
it compiled fine. But perhaps I should have replaced it with module.h.
I'll look into it.

Thanks!

-- Steve


