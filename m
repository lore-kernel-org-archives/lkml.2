Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab2EPBfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:35:45 -0400
Received: from mail.vyatta.com ([76.74.103.46]:58685 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757841Ab2EPBfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:35:43 -0400
Date: Tue, 15 May 2012 18:35:36 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: ipv4 and ipv6: Convert
 printk(KERN_DEBUG to pr_debug
Message-ID: <20120515183536.2cac1e29@nehalam.linuxnetplumber.net>
In-Reply-To: <1fd8285e798ec9b3817c790a67b2bb655ffc931b.1337126963.git.joe@perches.com>
References: <cover.1337126962.git.joe@perches.com>
	<1fd8285e798ec9b3817c790a67b2bb655ffc931b.1337126963.git.joe@perches.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 17:11:54 -0700
Joe Perches <joe@perches.com> wrote:

> Use the current debugging style and enable dynamic_debug.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This changes the action of the system. By default:
  printk(KERN_DEBUG "foo\n");
is enabled all the time and prints to log with debug level.

But your version
  pr_debug("foo\n");
defaults to being dropped until the system is built with dynamic
debug, and that particular debug instance is enabled.

Since these are all useful, but low priority messages, not I
don't think disabling them by default is such a great idea now.

