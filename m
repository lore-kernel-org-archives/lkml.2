Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab0DTVYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:24:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42584
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755260Ab0DTVYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:24:02 -0400
Date: Tue, 20 Apr 2010 14:24:05 -0700 (PDT)
Message-Id: <20100420.142405.228805796.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: raise.sail@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: A possible bug in reqsk_queue_hash_req()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1271761611.3845.223.camel@edumazet-laptop>
References: <i2x9b948ee41004200335vc229a59cvc0a08c35c949d7dd@mail.gmail.com>
	<1271761611.3845.223.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 20 Apr 2010 13:06:51 +0200

> I believe its not really necessary, because we are the only possible
> writer at this stage.
> 
> The write_lock() ... write_unlock() is there only to enforce a
> synchronisation with readers.
> 
> All callers of this reqsk_queue_hash_req() must have the socket locked

Right.

In fact there are quite a few snippets around the networking
where we use this trick of only locking around the single
pointer assignment that puts the object into the list.

And they were all written by Alexey Kuznetsov, so they must
be correct :-)
