Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab2BFTUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:20:01 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:46011 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab2BFTUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:20:00 -0500
X-Sasl-enc: 9wLh6mQlIHieH+rXTFMGwnl9D1FQ6Cts21L0c1aK63+Z 1328555999
Date: Mon, 6 Feb 2012 11:18:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/6] oom: Make find_lock_task_mm() sparse-aware
Message-ID: <20120206191854.GA16702@kroah.com>
References: <20120203163056.GA4190@redhat.com>
 <20120206162930.GA5117@oksana.dev.rtsoft.ru>
 <20120206163542.GA10104@kroah.com>
 <20120206185909.GB7741@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120206185909.GB7741@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 10:59:09PM +0400, Anton Vorontsov wrote:
> On Mon, Feb 06, 2012 at 08:35:42AM -0800, Greg KH wrote:
> [...]
> > > -extern struct task_struct *find_lock_task_mm(struct task_struct *p);
> > > +extern struct task_struct *__find_lock_task_mm(struct task_struct *p);
> > > +
> > > +#define find_lock_task_mm(p)						\
> > > +({									\
> > > +	struct task_struct *__ret;					\
> > > +									\
> > > +	__cond_lock(&(p)->alloc_lock, __ret = __find_lock_task_mm(p));	\
> > > +	__ret;								\
> > > +})
> > 
> > Please use the proper "do...while" style thing here for multi-line,
> > complex #defines like the rest of the kernel does so that you don't end
> > up debugging horrible problems later.
> 
> Unfortunately this isn't possible in this case. Unlike '({})' GCC
> extension, do-while statement does not evaluate to a value, i.e.
> 'x = do { 123; } while (0);' is illegal.

Ah, you are right, my bad, sorry about that.

greg k-h
