Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0H3APD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 20:15:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0H3APB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 20:15:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Namhyung Kim <namhyung@gmail.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/43] ptrace cleanups
In-Reply-To: Namhyung Kim's message of  Friday, 27 August 2010 18:41:46 +0900 <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
X-Windows: a terminal disease.
Message-Id: <20100830001454.DC8FD400D9@magilla.sf.frob.com>
Date: Sun, 29 Aug 2010 17:14:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am fine with the s/long/unsigned long/ signature changes.  Adding
temporaries to avoid the repeated casts is fine too.  All that will
compile away to the same code we have now.  But please do it without
changing put_user/get_user calls to copy_{to,from}_user.  With a
temporary or two you'll still have fewer casts than before.  IMHO you
should at least do a separate follow-on patch for anything that actually
changes the compiled code vs just the cosmetic type cleanups.


Thanks,
Roland
