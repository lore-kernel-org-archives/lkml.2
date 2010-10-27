Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab0J0UjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:39:15 -0400
Received: from mail.candelatech.com ([208.74.158.172]:48860 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0J0UjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:39:13 -0400
Message-ID: <4CC88DDA.2030106@candelatech.com>
Date: Wed, 27 Oct 2010 13:38:50 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nelson Elhage <nelhage@ksplice.com>
CC: Robert Olsson <robert.olsson@its.uu.se>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eugene Teo <eugene@redhat.com>
Subject: Re: [PATCH] pktgen: Remove a dangerous debug print.
References: <1288206788-21063-1-git-send-email-nelhage@ksplice.com>
In-Reply-To: <1288206788-21063-1-git-send-email-nelhage@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 12:13 PM, Nelson Elhage wrote:
> We were allocating an arbitrarily-large buffer on the stack, which would allow a
> buggy or malicious userspace program to overflow the kernel stack.
>
> Since the debug printk() was just printing exactly the text passed from
> userspace, it's probably just as easy for anyone who might use it to augment (or
> just strace(1)) the program writing to the pktgen file, so let's just not bother
> trying to print the whole buffer.

Maybe just allocate that buffer on the heap instead of stack?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

