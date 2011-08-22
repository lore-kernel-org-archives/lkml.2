Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1HVOQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:16:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48415 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab1HVOQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:16:50 -0400
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Date: Mon, 22 Aug 2011 16:13:49 +0200
In-Reply-To: <1313786266-9585-3-git-send-email-dzickus@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
	 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314022429.24275.30.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-19 at 16:37 -0400, Don Zickus wrote:
> +int register_nmi_handler(unsigned int type, nmi_handler_t handler,
> +                       unsigned long nmiflags, const char *devname)
> +{
> +       struct nmiaction *action;
> +       int retval;
> +
> +       if (!handler)
> +               return -EINVAL;
> +
> +       action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
> +       if (!action)
> +               return -ENOMEM;
> +
> +       action->handler = handler;
> +       action->flags = nmiflags;
> +       action->name = devname; 

So you assume the string passed as devname remains stable..


> +
> +       retval = __setup_nmi(type, action);
> +
> +       if (retval)
> +               kfree(action);
> +       
> +       return retval;
> +}
> +EXPORT_SYMBOL(register_nmi_handler);

Also, I'd use _GPL, the current register_die_notifier() is also.
Preferably I'd not export NMI stuff at all.
