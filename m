Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab0IUJzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:55:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60605 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab0IUJzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UXMMSTQpkpEysKbGDBBhDaVwnOLrTV/9fvs9QjrhwWJEfE9hM1KkkzvIDY5FLUlF4n
         je38xMvKNYBl7RaqdIXH8cEh4/2YQGX3Nf6bQxaxiDdedXKbBM2sKUc+LWjCczXZeBqG
         DJfR22mqhqRsS8qeRbIaK059/BjRQFjvIWF4o=
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100921093853.GA8664@ff.dom.local>
References: <20100921091248.GA8424@ff.dom.local>
	 <1285060860.2617.158.camel@edumazet-laptop>
	 <20100921093853.GA8664@ff.dom.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 11:55:48 +0200
Message-ID: <1285062948.2617.204.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 21 septembre 2010 à 09:38 +0000, Jarek Poplawski a écrit :
> On Tue, Sep 21, 2010 at 11:21:00AM +0200, Eric Dumazet wrote:

> I hope you're right with this.
> 
> > 
> > I liked the :
> > 
> > <check everything without changing state>
> > if something wrong
> > 	goto slow_path
> > else
> > 	<OK, lets do destructive things>
> > 
> 
> But it's an optimization of the "unlikely" case btw. ;-)
> 

This is a bug fix, in a complex function.

in -next branch, we can try to be smart, adding more code in slow_path
to revert what was done in the hope fast path would be taken.
And pray we dont add another bug :)


