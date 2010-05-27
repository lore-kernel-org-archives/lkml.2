Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab0E0NUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:20:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345Ab0E0NUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:20:34 -0400
Message-ID: <4BFE7199.7060609@redhat.com>
Date: Thu, 27 May 2010 16:20:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Xiantao Zhang <xiantao.zhang@intel.com>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       kvm@vger.kernel.org, kvm-ia64@vger.kernel.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/17] arch/ia64/kvm: Add missing spin_unlock
References: <Pine.LNX.4.64.1005261756490.23743@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005261756490.23743@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 06:57 PM, Julia Lawall wrote:
> From: Julia Lawall<julia@diku.dk>
>
> Add a spin_unlock missing on the error path.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @@
> expression E1;
> @@
>
> * spin_lock(E1,...);
>    <+... when != E1
>    if (...) {
>      ... when != E1
> *   return ...;
>    }
>    ...+>
> * spin_unlock(E1,...);
> //</smpl>
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

