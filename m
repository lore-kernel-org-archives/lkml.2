Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2JHUqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:46:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43750 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab2JHUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:46:40 -0400
Date: Mon, 8 Oct 2012 13:46:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mpol_to_str revisited.
In-Reply-To: <20121008151552.GA10881@redhat.com>
Message-ID: <alpine.DEB.2.00.1210081344440.18768@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com> <20121008151552.GA10881@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2012, Dave Jones wrote:

> If pol->mode was poisoned, that smells like we have a race where policy is getting freed
> while another process is reading it.
> 
> Am I missing something, or is there no locking around that at all ?
> 

The only thing that is held during the read() is a reference to the 
task_struct so it doesn't disappear from under us.  The protection needed 
for a task's mempolicy, however, is task_lock() and that is not held.
