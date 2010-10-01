Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0JAObm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:31:42 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:38590 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab0JAObl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:31:41 -0400
X-Spam-Processed: digidescorp.com, Fri, 01 Oct 2010 09:31:40 -0500
	(not processed: message was sent from localhost)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=18902378fd=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Date: Fri, 01 Oct 2010 09:31:39 -0500
From: "Steve Magnani" <steve@digidescorp.com>
To: "David Howells" <dhowells@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH][RESEND] nommu: add anonymous page memcg accounting
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <WC20101001143139.810346@digidescorp.com>
X-Mailer: WorldClient 10.1.1
In-Reply-To: <5206.1285943095@redhat.com>
References: <1285929315-2856-1-git-send-email-steve@digidescorp.com> <5206.1285943095@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:
> 
> Do we really need to do memcg accounting in NOMMU mode?  Might it be
> better to just apply the attached patch instead?
> 
> David
> ---
> diff --git a/init/Kconfig b/init/Kconfig
> index 2de5b1c..aecff10 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -555,7 +555,7 @@ config RESOURCE_COUNTERS
>  
>  config CGROUP_MEM_RES_CTLR
>  	bool "Memory Resource Controller for Control Groups"
> -	depends on CGROUPS && RESOURCE_COUNTERS
> +	depends on CGROUPS && RESOURCE_COUNTERS && MMU
>  	select MM_OWNER
>  	help
>  	  Provides a memory resource controller that manages both anonymous

If anything I think nommu is one of the better applications of memcg. Since nommu typically == 
embedded, being able to put potential memory pigs in a sandbox so they can't destabilize the 
system is a Good Thing. That was my motivation for doing this in the first place and it works 
quite well.

If it would be better to make nommu memcg contingent on some new Kconfig option, we can do 
that. 

Steve


