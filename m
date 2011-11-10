Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1KJRpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:45:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64307 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1KJRpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:45:22 -0500
Date: Thu, 10 Nov 2011 09:45:15 -0800
From: Tejun Heo <tj@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
Message-ID: <20111110174515.GI27258@google.com>
References: <4EBC0696.9030103@parallels.com>
 <4EBC06DB.3090202@parallels.com>
 <20111110173009.GH27258@google.com>
 <4EBC0B87.1030305@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBC0B87.1030305@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 10, 2011 at 09:36:07PM +0400, Pavel Emelyanov wrote:
> > Hmmm... is it necessary to be able to replicate pids on all
> > namespaces? 
> 
> Not for us (I mean OpenVZ). But since we should (in theory) be able to
> recreate the nested set of namespaces it would be good if the API allows
> for this from the very beginning.

I see.

> > Also, isn't it a bit weird to be able to request PIDs in
> > the namespaces which is beyond the task which requested cloning?
> 
> It is, but the last_pid != 0 check will abort this request with EPERM :)
> Do you think some other behavior would be better?

Right, missed that part.  The only suggestion then is that clearing
wants_pid to NULL isn't an optimization but should be part of API -
ie. want_pids is 0 terminated; otherwise, the caller must know at
which ns depth it is.

Thanks.

-- 
tejun
