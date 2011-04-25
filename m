Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1DYL0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:26:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49820 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149Ab1DYL0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RVaNOJTXOOemLx2QiRgmAZtjEoAgTYkNlLeRG2H5JSAV+AcP2g82I01k/FFDW3P5Hf
         kplneXAVFAcMRIRybyB2Fo3kBByBiaV7yrKqVAqxuHsYI2vXDtxY+QyqSd4XpWEzWM9l
         THZKA9RJtQXQH0xcMXizPsqA78LiDgZQKMEuc=
Date: Mon, 25 Apr 2011 13:26:33 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/7] signal: cleanup sys_rt_sigprocmask()
Message-ID: <20110425112633.GK17734@mtj.dyndns.org>
References: <20110418134421.GA15951@redhat.com>
 <20110418134700.GI15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134700.GI15951@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 03:47:00PM +0200, Oleg Nesterov wrote:
> sys_rt_sigprocmask() looks unnecessarily complicated, simplify it.
> We can just read current->blocked lockless unconditionally before
> anything else and then copy-to-user it if needed.  At worst we
> copy 4 words on mips.
> 
> We could copy-to-user the old mask first and simplify the code even
> more, but the patch tries to keep the current behaviour: we change
> current->block even if copy_to_user(oset) fails.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
