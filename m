Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388Ab0COQUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:20:42 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39049 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965346Ab0COQUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MD8ayYraTRZUc5l/Vvlzq/Xvl/RiEWTfOFvf+3U3Wq+x7pH7ShE2vmr7U4186N5WGb
         7IzTMa50klxzbnFaSic8tSGq7ZIJTroakjwrXpkZvS1g6J5/wxqnJLX0gHDY+Kz9GFLJ
         oSQM6S69Dzvg0uMEBJ/hT4wJCHtXJBhNR067k=
Subject: Re: Seeing TCP socket options (nodelay, cork, etc) in Linux procfs
 or elsewhere?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "MacCana, Mike" <mike.maccana@credit-suisse.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5608FA8A997F1A46B7E985494F8478DD07930AF1@ELON17P32003A.csfb.cs-group.com>
References: <5608FA8A997F1A46B7E985494F8478DD07930AF1@ELON17P32003A.csfb.cs-group.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Mar 2010 17:20:31 +0100
Message-ID: <1268670031.3154.35.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 15 mars 2010 à 15:49 +0000, MacCana, Mike a écrit :
> Hi kernel folks,
>  
> I was wondering if there was a standard location to see TCP socket
> options (eg, nodelay, cork, etc), perhaps via procfs or some other
> means? I'd like to check whether arbitrary apps (for which I don't have
> code) are using particular TCP options. 
>  
> Wandering round /proc/net hasn't turned up anything yet, and after a
> quick:
> socket.setsockopt(0, 1, 1)
> to enable NODELAY I can't see any obvious difference in procfs or
> netstat output (where other Unixes seem to put this info). hat's the
> best way to see TCP options on sockets created by others' code?
> 

There is limited support given by ss command (part of iproute2) :

ss -emoi

ESTAB       0      0                                55.225.18.5:4900
55.225.18.5:50000    uid:501 ino:135421 sk:c3b405c0
	 mem:(r0,w0,f4096,t0) ts bic wscale:6,6 rto:201 rtt:1/0.5 ato:40 cwnd:3
send 393.2Mbps rcv_space:32768


But CORK flag is not exported yet (its usually a volatile flag, at least
with Apache server)



