Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2KMJdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:33:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49616 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab2KMJda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:33:30 -0500
Message-ID: <50A213DF.1040103@gmail.com>
Date: Tue, 13 Nov 2012 17:33:19 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Christoph Lameter <cl@linux.com>
CC: David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/9] net: xfrm: use __this_cpu_read per-cpu helper
References: <50A1A7C9.3060703@gmail.com> <20121113072101.GG22290@secunet.com>
In-Reply-To: <20121113072101.GG22290@secunet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steffen Klassert said, at 2012/11/13 15:21:
> 
> This should just fetch the tfm pointer, so why exactly __this_cpu_read
> is better than __this_cpu_ptr? Please keep in mind that performance is
> not the most important thing here. It's much more important that it
> works in any case.
 
[0/9] describes why we should submit this series patches.
you are not included in original mail.

this_cpu_ptr relocates and address. this_cpu_read() relocates the address
and performs the fetch. If you want to operate on rda(defined as per_cpu) 
then you can only use this_cpu_ptr. this_cpu_read() saves you more instructions
since it can do the relocation and the fetch in one instruction.

More info, please refer to http://www.spinics.net/lists/kernel/msg1435153.html

