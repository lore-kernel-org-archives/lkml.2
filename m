Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0FNU0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:26:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab0FNU0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:26:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=mHG2mdGeFH0sSZ8WLkmw7o53F+yQU1y0EpRZP1R71GS+FRNpG8RfmFNhXL8B12vEu
	un+mI73GjSKUyy++OHu2A==
Date: Mon, 14 Jun 2010 13:26:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andy Whitcroft <apw@canonical.com>
cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kbuild: fix LOCALVERSION handling to match
 description
In-Reply-To: <1276508470-21731-1-git-send-email-apw@canonical.com>
Message-ID: <alpine.DEB.2.00.1006141325080.25461@chino.kir.corp.google.com>
References: <1276508470-21731-1-git-send-email-apw@canonical.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, Andy Whitcroft wrote:

> In the commit below the version string handling was modified, adding
> a '+' where no other version information was supplied:
> 
>     commit 85a256d8e0116c8f5ad276730830f5d4d473344d
>     Author: David Rientjes <rientjes@google.com>
>     Date:   Wed Jan 13 13:01:05 2010 -0800
> 
> From the commit the intent was as below:
> 
>      - when CONFIG_LOCALVERSION_AUTO is disabled, a `+' is appended if the
>        repository has been revised beyond a tagged commit and LOCALVERSION=
>        was not passed to "make".
> 
> However if the user supplies an empty LOCALVERSION on the command line
> the plus suffix is still added.  This form is useful in the case where
> the build environment knows that the version as specified is correct and
> complete but does not correspond to a specific tag.
> 
> This patch changes the implementation to match the documentation
> such that specifying LOCALVERSION= on the build line is sufficient
> to suppress any suffix.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Acked-by: David Rientjes <rientjes@google.com>

This should be pushed for rc4.
