Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab1JNTxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:53:36 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51202 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1JNTxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:53:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=GLQEt3eBV/pSQORXWMfS/wh3HHyjllPNI8AoE5794Qmy8d+NJNgDKedh+oPjxXh2G
	TQAA0CDLUuGiOWjMkNhuQ==
Date: Fri, 14 Oct 2011 12:53:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [slabinfo PATCH] Fix off-by-one after readlink() call
In-Reply-To: <4E9870A8.2010905@intra2net.com>
Message-ID: <alpine.DEB.2.00.1110141252480.24783@chino.kir.corp.google.com>
References: <4E9869B4.6080702@intra2net.com> <alpine.DEB.2.00.1110141214270.6411@router.home> <4E9870A8.2010905@intra2net.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Thomas Jarosch wrote:

> The problem is the line after the readlink() call:
> 
> buffer[count] = '\0';
> 
> The common technique is to reduce the buffer size by one.
> Another fix would be to check
> 
> "
> if (count < 0 || count == sizeof(buffer))
>     fatal();
> "
> 
> Reducing the buffer size by one is easier IMHO.
> 

I think this should be used for changelog.

Acked-by: David Rientjes <rientjes@google.com>
