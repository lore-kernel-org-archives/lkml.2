Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab0J0MqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:46:10 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50983 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0J0MqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:46:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f9qUfWP2WFjHlR6zs15moiawdvN3CJZJjZSdB982Ib+RWDr/RGeH5F6qfjEJLpIMpz
         47BGb05yZxTD5quIU0KrIHInE+/MlgyoTpyBEZ88HI3D+zIIHufVi+r+q1x1z45g7ZmB
         wpC3WFueANKnLZx5+a+Ct2mgY64hCPvSOYyPc=
Subject: Re: [patch 116/176] fs: allow for more than 2^31 files
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        davem@davemloft.net, holt@sgi.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101027115946.GA26335@lst.de>
References: <201010262122.o9QLMiZG016728@imap1.linux-foundation.org>
	 <20101027115946.GA26335@lst.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 14:46:02 +0200
Message-ID: <1288183562.2709.94.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 13:59 +0200, Christoph Hellwig a écrit :
> This patch breaks the binary sysctl ABI.  It probably doesn't matter
> as no one actually used it, but it might be better idea to just remove
> this node from the binary sysctl tree.
> 

Good point

To be precise, sysctl() truncates the value to low order 32bit value,
because it internally uses simple_strtoul(), then a put_user()

An old binary using sysctl() to fetch FS_MAXFILE could break on SGI
machines. I am not sure we should remove sysctl FS_MAXFILE because of
this rare case.



