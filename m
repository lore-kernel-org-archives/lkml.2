Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab1DVWgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:36:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62186 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab1DVWgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=taJkX0svNfYfewsO7S/E/LhKc1/kM/50gFGePxHtd5/TkMjSh5Css+7867LsJFCEEK
         5Q3AhtvAEMt3B6IxhK/g==
Date: Fri, 22 Apr 2011 15:35:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: james_p_freyensee@linux.intel.com
cc: akpm@linux-foundattion.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com
Subject: Re: [PATCH] export kernel call get_task_comm().
In-Reply-To: <1303511188-728-2-git-send-email-james_p_freyensee@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1104221534380.3873@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com> <1303511188-728-2-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011, james_p_freyensee@linux.intel.com wrote:

> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This allows drivers who call this function to be compiled modularly.
> Otherwise, a driver who is interested in this type of functionality
> has to implement their own get_task_comm() call, causing code
> duplication in the Linux source tree.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>

I still suggest that we implement finer-grained protection for tsk->comm 
through get_task_comm(), though, because it's going to be difficult to 
know whether task_lock(tsk) is held in all contexts we'll want to call it; 
task_lock(tsk) is used to protect many members of task_struct.
