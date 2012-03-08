Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab2CHTm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:42:58 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50582 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2CHTm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:42:56 -0500
Message-ID: <1331235766.11248.404.camel@twins>
Subject: Re: [PATCH] x86,nmi: Fix page faults by nmiaction if kmemcheck is
 enabled
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Date: Thu, 08 Mar 2012 20:42:46 +0100
In-Reply-To: <1331234231-18914-1-git-send-email-dzickus@redhat.com>
References: <1331234231-18914-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 14:17 -0500, Don Zickus wrote:

> +int __register_nmi_handler(unsigned int type, unsigned int nmiflags,
> +                                               struct nmiaction *na)
>  {
> +       if (!na->handler)
>                 return -EINVAL;
>  
> +       na->flags = nmiflags;
>  
> +       return __setup_nmi(type, na);
>  }
> +EXPORT_SYMBOL_GPL(__register_nmi_handler);

Put the na->flags thing in the CPP bit, put the !handler check in
__setup_nmi() and loose the pointless wrappery?

>  void unregister_nmi_handler(unsigned int type, const char *name)
>  {
> +       __free_nmi(type, name);
>  }
>  
>  EXPORT_SYMBOL_GPL(unregister_nmi_handler); 

That's another quite pointless wrapper there..
