Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab2AZJQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:16:18 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:6890 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2AZJQQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 26 Jan 2012 04:16:16 -0500
Message-Id: <4F212835020000780006F264@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 26 Jan 2012 09:17:25 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <socketpair@gmail.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Fwd: BUG in
 linux+v3.2.1/drivers/xen/xen-pciback/pci_stub.c
References: <CAEmTpZHkKB29FLWqs0R=uD1zXBOJkfSstGgMM=8bA1VVXGT+wQ@mail.gmail.com>
 <CAEmTpZH+OeQO=RNBFh_+j_QCmPa8sGhV_OOqqsiKUMmjhBwESw@mail.gmail.com>
 <20120125163910.GC23999@phenom.dumpdata.com>
 <20120125212214.GA29571@phenom.dumpdata.com>
In-Reply-To: <20120125212214.GA29571@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.01.12 at 22:22, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> --- a/drivers/xen/xen-pciback/xenbus.c
> +++ b/drivers/xen/xen-pciback/xenbus.c
> @@ -206,8 +206,9 @@ static int xen_pcibk_publish_pci_dev(struct 
> xen_pcibk_device *pdev,
>  		goto out;
>  	}
>  
> +	/* TODO: implement feature-use-decimal-for-devfn */
>  	err = xenbus_printf(XBT_NIL, pdev->xdev->nodename, str,
> -			    "%04x:%02x:%02x.%02x", domain, bus,
> +			    "%04x:%02x:%02x.%1x", domain, bus,
>  			    PCI_SLOT(devfn), PCI_FUNC(devfn));
>  
>  out:

If you are concerned about compatibility (as the added comment
suggests), then removing the leading zero is not an option either.

However, as long as all parsers of the string use plain %x or %d,
there's no issue here and you could as well use %d here too (as
PCI functions are always in the 0-7 range, which is identically
represented in octal [important for the case of a leading zero],
decimal, and hex).

Bottom line - just add the comment here, and leave the format
unchanged, or change the format to %d right away.

Jan

