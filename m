Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1I3HuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:50:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:19826 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1I3HuH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:4:1>);
	Fri, 30 Sep 2011 03:50:07 -0400
Message-Id: <4E8590CD0200007800058ABA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 30 Sep 2011 08:50:05 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Cc: "Dan Carpenter" <error27@gmail.com>, <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 3/9] xen/pciback: Check if the device
	 is found instead of blindly assuming so.
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
 <1317325971-21603-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1317325971-21603-4-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 29.09.11 at 21:52, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Just in case it is not found, don't try to dereference it.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xen-pciback/pci_stub.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/pci_stub.c 
> b/drivers/xen/xen-pciback/pci_stub.c
> index d985b65..55086e9 100644
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -222,6 +222,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>  	}
>  
>  	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
> +	if (!found_psdev)
> +		return;

If this happens, it's a bug (backend controller found the device, but
the generic backend code didn't), so I would say minimally a WARN_ON()
should be issued here.

Jan

>  
>  	/*hold this lock for avoiding breaking link between
>  	* pcistub and xen_pcibk when AER is in processing




