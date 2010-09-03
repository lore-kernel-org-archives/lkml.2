Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0ICNwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:52:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52715 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0ICNwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:52:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jXQlmwltzIJZGrRut4sAV+fUvHlVMdXB/vSBlqjBzQzpBif1AOoTZnlkq+5hKf24xS
         d+ATcGtOU1hsyvTV6ik8hcI/nHMZk9sLUkAf8y9spSz9H94Hft/wEo2qLJN1bE2s1Mgn
         lQhlRH6koDFq15F7U2r8p1lHgNYWhyDySmfts=
Message-ID: <4C80FD9E.5040408@gmail.com>
Date: Fri, 03 Sep 2010 15:52:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: audit_tree: sleep inside atomic
References: <4C1F8217.5020909@gmail.com>
In-Reply-To: <4C1F8217.5020909@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ideas, comments?

On 06/21/2010 05:15 PM, Jiri Slaby wrote:
> Hi,
> 
> stanse found a sleep inside atomic added by the following commit:
> commit fb36de479642bc9bdd3af251ae48b882d8a1ad5d
> Author: Eric Paris <eparis@redhat.com>
> Date:   Thu Dec 17 20:12:05 2009 -0500
> 
>     audit: reimplement audit_trees using fsnotify rather than inotify
> 
>     Simply switch audit_trees from using inotify to using fsnotify for it's
>     inode pinning and disappearing act information.
> 
>     Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> 
> In untag_chunk, there is
>   spin_lock(&entry->lock);
>   ...
>   new = alloc_chunk(size);
>   ...
>   spin_unlock(&entry->lock);
> 
> with
> static struct audit_chunk *alloc_chunk(int count)
> {
>   struct audit_chunk *chunk;
>   ...
>   chunk = kzalloc(size, GFP_KERNEL);
> 
> But this can sleep. How big the allocations are? Could it be ATOMIC or
> moved outside the spinlock?
> 
> thanks,
-- 
js
