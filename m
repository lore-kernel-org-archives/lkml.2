Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab2H3U5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 16:57:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58585 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2H3U5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 16:57:34 -0400
Date: Thu, 30 Aug 2012 13:57:29 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 01/11] vmci_context.patch: VMCI context list operations.
Message-ID: <20120830205729.GA3276@kroah.com>
References: <20120824171042.4775.36871.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20120824171551.4775.87175.stgit@promb-2n-dhcp175.eng.vmware.com>
 <15333E71B3DDCB48A90165AD57993F285685DB43D7@exch-mbx-114.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15333E71B3DDCB48A90165AD57993F285685DB43D7@exch-mbx-114.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 09:38:08AM -0700, George Zhang wrote:
> +/* VMCICptBufInfo: Used to set/get current context's checkpoint state. */
> +struct vmci_ctx_chkpt_buf_info {
> +       uint64_t cptBuf;
> +       uint32_t cptType;
> +       uint32_t bufSize;
> +       int32_t result;
> +       uint32_t _pad;
> +};

Please use the proper kernel types when you are passing structures
across the kernel/user boundry (hint, you should NEVER be using the
uint*_t types in the kernel).  You need to fix up all of the structures
that you pass through your ioctl, to use the correct __ types, and fix
up everything else to use the other types.

Also, you have a crazy variable naming scheme everywhere, remember, you
can use vowels and '_' characters :)

greg k-h
