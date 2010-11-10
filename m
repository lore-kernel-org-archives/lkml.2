Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab0KJPyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:54:37 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42623 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab0KJPyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:54:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xUFdAJLc1U/SrkrNhxSN6412kSFvciLOcqIqP9lqLwZu/Y8Y7/EqZLuXfLojT9710u
         vd0xYz2RBfUHc/NPtfrB5awNyc9Z0bDftEouNX83fREJ16xB1PhENNSJugJoY3ma2/NP
         5/qW/wMbEi4xygS+5ykI72DkpZRO9P6bSri+Y=
Date: Wed, 10 Nov 2010 18:54:26 +0300
From: Vasiliy Kulikov <segooon@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: David Miller <davem@davemloft.net>, kernel-janitors@vger.kernel.org,
        jon.maloy@ericsson.com, allan.stephens@windriver.com,
        tipc-discussion@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: tipc: fix information leak to userland
Message-ID: <20101110155426.GA6484@albatros>
References: <1288545032-16481-1-git-send-email-segooon@gmail.com>
 <20101109.092630.260076036.davem@davemloft.net>
 <20101109203317.GA24933@albatros>
 <4CDA88FE.8040801@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDA88FE.8040801@bfs.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 12:58 +0100, walter harms wrote:
> NTL the core problem was that sizeof sa_data is 14 while dev->name is IFNAMESZ=15.

With this code it is NOT a bug because the output buffer is much bigger
than 14 (128 bytes).  I think it was just designed to overflow 14 bytes,
assign sa_data[14] = 0 and ignore it (lack of snprintf() those days?).

Anywhere else sa_data[14] = ... is a bug.

-- 
Vasiliy
