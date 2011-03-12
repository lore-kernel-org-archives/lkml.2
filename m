Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1CLLlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 06:41:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48816 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1CLLlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 06:41:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V6/4ftIibh+ZVJvscmEGmxdiExvehvhVvk5aF/PB2UKox86XBLc6pjBAE5FKRSWitg
         YvMQaStIWtPmCDFJjuMsL9vJ2XjHbTIWowidVu5o7JUwtim5L5rK+J+I6GWNHZcPND1H
         KjCIPjckN9TQJKzxYoqU75Ozf4NX7ab/MvFd4=
Date: Sat, 12 Mar 2011 12:41:01 +0100
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, x86@kernel.org
Subject: Re: [x86 this_cpu_has V1 2/4] x86: Avoid passing struct cpuinfo
 pointer to mce_available
Message-ID: <20110312114101.GB2005@htj.dyndns.org>
References: <20110311162310.124405247@linux.com>
 <20110311162334.162046931@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311162334.162046931@linux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 10:23:12AM -0600, Christoph Lameter wrote:
> If we do not pass the pointer to cpuinfio to mce available then its possible
> to use this_cpu_has.
> 
> There are two use cases of mce_available: One with the current processor
> and one with the boot cpu. Define a function for both cases. However, there
> is only one case in which boot_mce_available is used. If we somehow can
> get rid of that then the patch could be simplified.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Christoph, I'm not sure about this one.  None of the conversions is in
hot path, which would be okay if the resulting code was simpler but,
well, it isn't necessarily worse but not distinctively better either,
so I fail to see the merits of this conversion.  I'll resend the other
three towards x86 tree.

Thank you.

-- 
tejun
