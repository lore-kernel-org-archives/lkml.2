Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab2BOOIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:08:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63275 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2BOOIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:08:30 -0500
Message-ID: <1329314906.2437.36.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH] char random: fix boot id uniqueness race (v2)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Greg Kroah-Hartman <greg@kroah.com>
Date: Wed, 15 Feb 2012 15:08:26 +0100
In-Reply-To: <20120215133505.GA3659@Krystal>
References: <20120215041014.GA15846@Krystal>
	 <1329284916.2555.34.camel@edumazet-laptop> <20120215133505.GA3659@Krystal>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 février 2012 à 08:35 -0500, Mathieu Desnoyers a écrit :

> That would make sense, as long as we're OK about turning a read-mostly
> operation into a fully serialized operation that requires to exchange
> the lock between processor cache-lines. But as you point out, it should
> be fairly unfrequently used.
> 
> Any particular reason to use a spin lock rather than a mutex ? I did put
> a mutex in my implementation assuming that it would be a little more
> RT-friendly.

generate_random_uuid(uuid) is very fast and doesnt sleep.



