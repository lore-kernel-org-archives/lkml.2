Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2KPTRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:17:11 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39623 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab2KPTRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:17:09 -0500
Date: Fri, 16 Nov 2012 11:17:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Cloos <cloos@jhcloos.com>
cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Likely mem leak in 3.7
In-Reply-To: <m3r4nuwipl.fsf@carbon.jhcloos.org>
Message-ID: <alpine.DEB.2.00.1211161115001.2788@chino.kir.corp.google.com>
References: <m3r4nuwipl.fsf@carbon.jhcloos.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, James Cloos wrote:

> The kernel does not log anything relevant to this.
> 

Can you do the following as root:

	dmesg -c > /dev/null
	echo m > /proc/sysrq-trigger
	dmesg > foo

and send foo inline in your reply?

> Slabinfo gives some odd output.  It seems to think there are negative
> quantities of some slabs:
> 
> Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
> :at-0000016               5632      16    90.1K 18446744073709551363/0/275  256 0   0 100 *a
> :t-0000048                3386      48   249.8K 18446744073709551558/22/119   85 0  36  65 *
> :t-0000120                1022     120   167.9K 18446744073709551604/14/53   34 0  34  73 *
> blkdev_requests            182     376   122.8K 18446744073709551604/7/27   21 1  46  55 
> ext4_io_end                348    1128   393.2K 18446744073709551588/0/40   29 3   0  99 a
> 

Can you send the output of

	zgrep CONFIG_SL[AU]B /proc/config.gz
	cat /proc/slabinfo
