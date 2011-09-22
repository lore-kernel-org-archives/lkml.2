Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab1IVXA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:00:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60078 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab1IVXA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:00:56 -0400
X-Sasl-enc: INn+aJLAybcVQ0hGzSwvKjE3cFJc9HR3cOEUBpz56WUv 1316732455
Date: Thu, 22 Sep 2011 15:38:09 -0700
From: Greg KH <greg@kroah.com>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: stable@kernel.org, Breno Leitao <leitao@linux.vnet.ibm.com>,
        lucaskt@linux.vnet.ibm.com, Alan Cox <alan@linux.intel.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: jsm: remove buggy write queue
Message-ID: <20110922223809.GA21159@kroah.com>
References: <1314202463-12297-1-git-send-email-cascardo@linux.vnet.ibm.com>
 <20110913175522.GB3592@oc1711230544.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913175522.GB3592@oc1711230544.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 02:55:23PM -0300, Thadeu Lima de Souza Cascardo wrote:
> jsm uses a write queue that copies from uart_core circular buffer. This
> copying however has some bugs, like not wrapping the head counter. Since
> this write queue is also a circular buffer, the consumer function is
> ready to use the uart_core circular buffer directly.
> 
> This buggy copying function was making some bytes be dropped when
> transmitting to a raw tty, doing something like this.
> 
> [root@hostname ~]$ cat /dev/ttyn1 > cascardo/dump &
> [1] 2658
> [root@hostname ~]$ cat /proc/tty/drivers > /dev/ttyn0
> [root@hostname ~]$ cat /proc/tty/drivers
> /dev/tty             /dev/tty        5       0 system:/dev/tty
> /dev/console         /dev/console    5       1 system:console
> /dev/ptmx            /dev/ptmx       5       2 system
> /dev/vc/0            /dev/vc/0       4       0 system:vtmaster
> jsm                  /dev/ttyn     250 0-31 serial
> serial               /dev/ttyS       4 64-95 serial
> hvc                  /dev/hvc      229 0-7 system
> pty_slave            /dev/pts      136 0-1048575 pty:slave
> pty_master           /dev/ptm      128 0-1048575 pty:master
> unknown              /dev/tty        4 1-63 console
> [root@hostname ~]$ cat cascardo/dump
> /dev/tty             /dev/tty        5       0 system:/dev/tty
> /dev/console         /dev/console    5       1 system:console
> /dev/ptmx            /dev/ptmx       5       2 system
> /dev/vc/0            /dev/vc/0       4       0 system:vtmaste[root@hostname ~]$
> 
> This patch drops the driver write queue entirely, using the circular
> buffer from uart_core only.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> ---
> 
> Hello, Greg.
> 
> This should probably go to 3.1 and stable releases, since it fixes a
> bug.

I already have this in my tree queued up for 3.2, so please remind me of
this when it hits Linus's tree during the 3.2 merge window.

thanks,

greg k-h
