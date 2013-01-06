Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3AFACK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 19:02:10 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39849 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab3AFACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 19:02:08 -0500
Subject: Re: Major network performance regression in 3.7
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20130105232913.GQ16031@1wt.eu>
References: <20130105214958.GA19814@1wt.eu>
	 <1357427926.1678.4771.camel@edumazet-glaptop>
	 <20130105232913.GQ16031@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jan 2013 16:02:03 -0800
Message-ID: <1357430523.1678.4901.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-06 at 00:29 +0100, Willy Tarreau wrote:

> > 2) Another possibility would be that Myri card/driver doesnt like very
> > well high order pages.
> 
> It looks like it has not changed much since 3.6 :-/ I really suspect
> something is wrong with memory allocation. I have tried reverting many
> patches affecting the mm/ directory just in case but I did not come to
> anything useful yet.
> 

Hmm, I was referring to TCP stack now using order-3 pages instead of
order-0 ones

See commit 5640f7685831e088fe6c2e1f863a6805962f8e81
(net: use a per task frag allocator)

Could you please post :

ethtool -S eth0



