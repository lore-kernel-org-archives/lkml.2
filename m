Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab0JBIeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 04:34:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61307 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0JBIeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 04:34:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=klv0+B1d+vVym2b8XyojseU2RzthdmrZ1B/XFa7rmNmJxUqNDvGXfaG68XopGZKSHk
         WhFtN/y6606reirN0GI47h2reoPXTTNGiMO5bFg40BhJYgYeaQpfpyNeLPoajg/rbTyl
         6UAMAxT4U67Sjr7SyTcwFr9/0ZbL6Wv0eLN2U=
Subject: Re: [PATCH 2.6.35.7] net: Fix the condition passed to
 sk_wait_event()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nagendra Tomar <tomer_iisc@yahoo.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <1286008051.2582.846.camel@edumazet-laptop>
References: <667106.4951.qm@web53706.mail.re2.yahoo.com>
	 <1286008051.2582.846.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 10:34:01 +0200
Message-ID: <1286008441.2582.851.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 02 octobre 2010 à 10:27 +0200, Eric Dumazet a écrit :

> Just wondering why you remove the test on sk->err ?
> 
> We want to break the loop If sk->sk_err is set, or state is ESTABLISHED
> or CLOSE_WAIT.

Hmm, reading the code again, I can see sk_err is tested in the loop, so
your code is better (sk_stream_wait_connect() returns an error after
your patch, instead of returning 0)

Could you please split your patch in two patches ?

The sk_stream_wait_connect() problems comes from commit
c1cbe4b7ad0bc4b1d9 ([NET]: Avoid atomic xchg() for non-error case)




