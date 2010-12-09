Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab0LINa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 08:30:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41266 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0LINa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 08:30:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A72sxB7oEAFWUwuUjdMwZUOeiUuPK/DQqm/tlZz11B9kvjH7i0DH/j5WcQoIZ1jehD
         ewm01lf+upz8ft5wrwBqr0iylTWHaEvIXkWm9pttybT9yDbKBoq3HuXjnlRd2S0UhQPR
         XylEgvwQBHD7TWBeeUXoRBdSpXcW/gheZbydc=
Subject: Re: [PATCH] kptr_restrict for hiding kernel pointers from
 unprivileged users
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <1291898801.2965.6.camel@Dan>
References: <1291863926.2965.1.camel@Dan>
	 <1291865039.2795.46.camel@edumazet-laptop>  <1291895472.2965.4.camel@Dan>
	 <1291898801.2965.6.camel@Dan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 14:30:20 +0100
Message-ID: <1291901420.4063.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 décembre 2010 à 07:46 -0500, Dan Rosenberg a écrit :
> > > So caller can not block BH ?
> > > 
> > > This seems wrong to me, please consider :
> > > 
> > > normal process context :
> > > 
> > > spin_lock_bh() ...
> > > 
> > > for (...)  
> > > 	{xxx}printf( ...   "%pK"   ...)
> > > 
> > > spin_unlock_bh();
> > > 
> > 
> > I will think about this and address it.
> 
> Would you be happier if I omitted the in_interrupt() check entirely?
> 

Well, it seems difficult to make a check here, its a generic function
that happens to be used from different contexts.

Even using in_irq() might be a problem.



