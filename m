Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab0KAP3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:29:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51647 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0KAP3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Vo8cXmUdtE4OW7m3ewqP2raUAmHXtWAihoyioQB0pNJcMnbtEfArCrASCuEJcu031o
         mTUH6w1GExF1Au0I5NB/j2F2y/oRytiapbH/HVnAwOgcGqG2iMtuHt566xKlp3FIrvac
         4zDmacpai6prYjXwiwr7iEmGKfntNM9MkY58w=
Subject: Re: [PATCH 3/3] fs: rcu protect inode hash lookups
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20101101134451.GN2715@dastard>
References: <1288589624-15251-1-git-send-email-david@fromorbit.com>
	 <1288589624-15251-4-git-send-email-david@fromorbit.com>
	 <1288604287.2660.94.camel@edumazet-laptop>  <20101101134451.GN2715@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 16:29:22 +0100
Message-ID: <1288625362.2660.108.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 02 novembre 2010 à 00:44 +1100, Dave Chinner a écrit :

> Perhaps you should rename that file "slab_destroy_by_rcu-tips.txt",
> because the current name seems unrelated to the contents. :/
> 

Hmm, I dont know, this doc really is about the nulls thing.

This stuff also addressed one problem I forgot to tell you about: During
a lookup, you might find an item that is moved to another chain by
another cpu, so your lookup is redirected to another chain. You can miss
your target.

You must find a way to detect such thing to restart the lookup at the
beginning (of the right chain).

Either you stick the chain number in a new inode field (that costs extra
memory), or you use the 'nulls' value that can let you know if you ended
your lookup in the right chain.



