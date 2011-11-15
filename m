Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1KOPUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:20:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37144 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1KOPUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:20:30 -0500
Date: Tue, 15 Nov 2011 07:20:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 1/4] Routine for generating an safe ID for kernel
 pointer
Message-ID: <20111115152023.GA18919@google.com>
References: <4EC24E9E.8040502@parallels.com>
 <4EC24EC1.7060203@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC24EC1.7060203@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 03:36:33PM +0400, Pavel Emelyanov wrote:
> +unsigned long gen_object_id(void *ptr)
> +{
> +	if (!ptr)
> +		return 0;
> +
> +	if (unlikely(!ptr_poison)) {
> +		spin_lock(&ptr_poison_lock);
> +		if (!ptr_poison)
> +			get_random_bytes(&ptr_poison, sizeof(ptr_poison));
> +		spin_unlock(&ptr_poison_lock);
> +	}

One thing that worries me about this is that there's one ptr_poison
for all id's and any single leak of a pointer value will make all ids
vulnerable.  If we're going to do this, let's segregate different id
spaces and use different poison values for each.

Thank you.

-- 
tejun
