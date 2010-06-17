Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828Ab0FQXFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:05:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335Ab0FQXFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:05:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ajCP6BRoWZQShwZezCGJuPiNGptKnFW3mAiRJO3GvWLmbcPK4NDUW/oiiCzDXInmf
	ZDEsSCbN15jrnG+EzN8iw==
Date: Thu, 17 Jun 2010 16:05:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Marek <mmarek@suse.cz>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Thelen <gthelen@google.com>,
       Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
Subject: Re: [PATCH] kbuild: Clean up and speed up the localversion logic
In-Reply-To: <1276782038-23441-1-git-send-email-mmarek@suse.cz>
Message-ID: <alpine.DEB.2.00.1006171603520.622@chino.kir.corp.google.com>
References: <4C1764CD.3080402@suse.cz> <1276782038-23441-1-git-send-email-mmarek@suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Michal Marek wrote:

> Now that we run scripts/setlocalversion during every build, it makes
> sense to move all the localversion logic there. This cleans up the
> toplevel Makefile and also makes sure that the script is called only
> once in 'make prepare' (previously, it would be called every time due to
> a variable expansion in an ifneq statement). No user-visible change is
> intended, unless one runs the setlocalversion script directly.
> 
> Reported-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Greg Thelen <gthelen@google.com>
> Cc: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
> 
> I tried to test this in various scenarios, but if anyone of you could give
> it a try, that would be great. The patch is against 2.6.35-rc3.
> 

I agree it would be better to move this to scripts/setlocalversion, thanks 
for looking into it.  I'll put this into my build cycles and see if it 
causes any issues in my workflow that is known to be good with 2.6.35-rc3.  
Since this is 2.6.36 material, it seems like we have some time.
