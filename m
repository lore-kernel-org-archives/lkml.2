Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1HXLqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:46:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:59849 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1HXLqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:46:23 -0400
Subject: Re: [V2][PATCH 2/6] x86, nmi: create new NMI handler routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 24 Aug 2011 13:46:09 +0200
In-Reply-To: <1314133866-30915-3-git-send-email-dzickus@redhat.com>
References: <1314133866-30915-1-git-send-email-dzickus@redhat.com>
	 <1314133866-30915-3-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314186369.24121.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 17:11 -0400, Don Zickus wrote:
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
> +       action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
> +
> +       retval = __setup_nmi(type, action);
> +
> +       if (retval)
> +               kfree(action);

you just leaked your kstrndup().

> +       
> +       return retval;
> +} 
