Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0LVQyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:54:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57230 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0LVQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:54:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U11su5U9731MNZYqLzBNDEq2s+1Nz8fa27iFV7qd0bjWam0G+Vvx9rsnqywvplgLa3
         C78olYqoZjGszaUajKcH+HTKpUY17YS9qoupHkTU6AY5eXlgqMxDBlkKUSxOA7pUHvO9
         8Lo49HZzrWvRvq+Vo6nzwVNi4uZKEXdncEXuY=
Subject: Re: 2.6.36.2 - loop on read /proc/net/tcp
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20101222134343.GC19998@beaver.vrungel.ru>
References: <20101222134343.GC19998@beaver.vrungel.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 17:54:09 +0100
Message-ID: <1293036849.3027.277.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 22 décembre 2010 à 16:43 +0300, Alexey Vlasov a écrit :
> Hi.
> 
> Has anyone seen such a bug at 2.6.36.2?
> # netstat -ntl
> Active Internet connections (only servers)
> Proto Recv-Q Send-Q Local Address           Foreign Address         State
> tcp        0      0 81.176.228.2:60608      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:8099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:8099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.7:8099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:8100       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:8100       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:8101       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:8101       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:20037      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:8102       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:8102       0.0.0.0:*               LISTEN
> tcp        0      0 127.0.0.1:3399          0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20040      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:38985      0.0.0.0:*               LISTEN
> tcp        0      0 0.0.0.0:873             0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20041      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20042      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:3306       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.3:3306       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.2:3306       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:9099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:9099       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20043      0.0.0.0:*               LISTEN
> tcp        0      0 0.0.0.0:139             0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:9100       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:9100       0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:20044      0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.5:33549      0.0.0.0:*               LISTEN
> ...
> First 30 lines are ok
> 
> but then go lines repeating in "eternal" loop:
> tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.3:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.7:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.3:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.7:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.3:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.4:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.7:80         0.0.0.0:*               LISTEN
> tcp        0      0 81.176.228.2:80         0.0.0.0:*               LISTEN
> 
> # cat /proc/net/tcp
> ...
> It can hang an hour or so. but not always actually.

Ouch...

Hmm, yes, I think I can do something about it, thanks for the report



