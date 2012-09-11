Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab2IKQEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:04:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab2IKQEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:04:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120911053128.3291.98346.stgit@localhost.localdomain>
References: <20120911053128.3291.98346.stgit@localhost.localdomain>
Date: Tue, 11 Sep 2012 09:04:37 -0700
X-Google-Sender-Auth: TuYPC7Sm2jFdwtwCjl4MI93Sl-w
Message-ID: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
Subject: Re: [PATCH v2] x86/mce: Honour bios-set CMCI threshold
From: Tony Luck <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: andi@firstfloor.org, bp@amd64.org, gong.chen@linux.intel.com,
        ananth@in.ibm.com, masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de, gregkh@suse.de,
        linux-edac@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:31 PM, Naveen N. Rao
<naveen.n.rao@linux.vnet.ibm.com> wrote:
> +       if (mce_bios_cmci_threshold)
> +               printk_once(KERN_INFO
> +                       "bios_cmci_threshold: Using bios-set threshold values for CMCI");

Do we really need this message? The user knows whether they gave
the command line option or not (and can check in /proc/cmdline if
they forgot whether they did). If it is needed, then you should add
a "\n" to it.

> +       if (mce_bios_cmci_threshold && bios_wrong_thresh) {
> +               printk_once(KERN_INFO
> +                       "bios_cmci_threshold: Some banks do not have valid thresholds set");
> +               printk_once(KERN_INFO
> +                       "bios_cmci_threshold: Make sure your BIOS supports this boot option");

Also need "\n"

-Tony
