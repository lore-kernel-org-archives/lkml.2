Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030741Ab2CVJ4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 05:56:15 -0400
Received: from ozlabs.org ([203.10.76.45]:41704 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287Ab2CVJ4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 05:56:11 -0400
Date: Thu, 22 Mar 2012 20:55:56 +1100
From: Anton Blanchard <anton@samba.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, rcj@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 05/17] pseries: Enabled the PFO-based RNG accelerator
Message-ID: <20120322205556.054c6169@kryten>
In-Reply-To: <1332365949.3858.32.camel@key-ThinkPad-W510>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	<1332365949.3858.32.camel@key-ThinkPad-W510>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

+#if defined(CONFIG_HW_RANDOM_PSERIES) || \
+	defined(CONFIG_HW_RANDOM_PSERIES_MODULE)
+#define OV5_PFO_HW_RNG		0x80	/* PFO Random Number
Generator */ +#else
+#define OV5_PFO_HW_RNG		0x00
+#endif

Milton tipped me off about this. We really don't want to be doing
ibm,client-architecture reboots every time a config option is changed.

Let's just hardwire it on.

Anton
