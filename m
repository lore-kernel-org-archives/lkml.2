Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab1BCVzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:55:10 -0500
Received: from smtp-out.google.com ([74.125.121.67]:54783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1BCVzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:55:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DpytiWTgrsN8FFhQuEN5l8TUj7ssY+PVN9CFHZblRqnT/XAKxrhWTXTM2y4Iqla8in
         zmI6C+liQyq8g51Lb6Tg==
Date: Thu, 3 Feb 2011 13:54:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 0/6] more detailed per-process transparent hugepage
 statistics
In-Reply-To: <20110201003357.D6F0BE0D@kernel>
Message-ID: <alpine.DEB.2.00.1102031354340.1307@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Dave Hansen wrote:

> I'm working on some more reports that transparent huge pages and
> KSM do not play nicely together.  Basically, whenever THP's are
> present along with KSM, there is a lot of attrition over time,
> and we do not see much overall progress keeping THP's around:
> 
> 	http://sr71.net/~dave/ibm/038_System_Anonymous_Pages.png
> 
> (That's Karl Rister's graph, thanks Karl!)
> 
> However, I realized that we do not currently have a nice way to
> find out where individual THP's might be on the system.  We
> have an overall count, but no way of telling which processes or
> VMAs they might be in.
> 
> I started to implement this in the /proc/$pid/smaps code, but
> quickly realized that the lib/pagewalk.c code unconditionally
> splits THPs up.  This set reworks that code a bit and, in the
> end, gives you a per-map count of the numbers of huge pages.
> It also makes it possible for page walks to _not_ split THPs.
> 

Nice!  I'd like to start using this patchset immediately, I'm hoping 
you'll re-propose it with the fixes soon.

Thanks Dave.
