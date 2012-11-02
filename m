Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834Ab2KBQ43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:56:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43796 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760621Ab2KBQ41 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 2 Nov 2012 12:56:27 -0400
Message-Id: <5094097302000078000A6288@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Nov 2012 16:57:07 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad@kernel.org>
Cc: "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] xen/hypercall: fix hypercall fallback code for
 very old hypervisors
References: <1351519698-11069-1-git-send-email-konrad.wilk@oracle.com>
 <1351519698-11069-2-git-send-email-konrad.wilk@oracle.com>
 <20121030154450.GA3000@phenom.dumpdata.com>
 <5090F5AA02000078000A5A0B@nat28.tlf.novell.com>
 <20121102164409.GB27213@konrad-lan.dumpdata.com>
In-Reply-To: <20121102164409.GB27213@konrad-lan.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.11.12 at 17:44, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> --- a/arch/x86/include/asm/xen/hypercall.h
> +++ b/arch/x86/include/asm/xen/hypercall.h
> @@ -359,18 +359,14 @@ HYPERVISOR_update_va_mapping(unsigned long va, pte_t new_val,
>  		return _hypercall4(int, update_va_mapping, va,
>  				   new_val.pte, new_val.pte >> 32, flags);
>  }
> +extern int __must_check xen_HYPERVISOR_event_channel_op_compat(int, void *);

Why don't you drop the HYPERVISOR_ now that you added the xen_?

>...
> +EXPORT_SYMBOL_GPL(xen_HYPERVISOR_event_channel_op_compat);

While this export is necessary, ...

>...
> +EXPORT_SYMBOL_GPL(xen_HYPERVISOR_physdev_op_compat);

... I would recommend not adding this one without need.

Jan

