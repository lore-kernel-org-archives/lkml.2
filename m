Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0FXNs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:48:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:7824 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab0FXNsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Vq34WutS4OmqCLbQhM6F6g1BCwcsT80nmFIkTIoYcj4McH/lnzmNoji1154/02AYlS
         zUT5Bpk9f/W12CT+wcVnsFUBvH50i6jfT2SC2x7kWf2gtcBiQuxL/YdVrmITRdljAhi/
         R7zElXpo1+++1HJ7fUua7XUKcRY+mp2F5rlmA=
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl()
From: Diego Elio =?UTF-8?Q?=E2=80=9CFlameeyes=E2=80=9D_?=
	 =?ISO-8859-1?Q?Petten=F2?= <flameeyes@gmail.com>
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org
In-Reply-To: <4C236063.9050302@hp.com>
References: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>
	 <4C235B75.2000807@hp.com> <1277385636.13544.67.camel@yamato.local>
	 <4C236063.9050302@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 15:44:41 +0200
Message-ID: <1277387081.13544.75.camel@yamato.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno gio, 24/06/2010 alle 09.40 -0400, Vlad Yasevich ha scritto:
> You don't call accept() on an SCTP SEQPACKET socket.  You can just
> read from it.

Okay I guess I'll send a patch to the man page to fix that then.

> This way, you'll ignore listening SOCK_STREAM sockets which will not
> have any
> data anyway, but you'll check out listening SOCK_SEQPACKET sockets
> that may have
> data waiting on them. 

Ah I think I see what you mean here: SIOCINQ would work for TCP-style
ESTABLISHED sockets _and_ SEQPACKET LISTENING sockets, right?

Will send the updated patch in a moment.

-- 
Diego Elio Pettenò — “Flameeyes”
http://blog.flameeyes.eu/

If you found a .asc file in this mail and know not what it is,
it's a GnuPG digital signature: http://www.gnupg.org/


