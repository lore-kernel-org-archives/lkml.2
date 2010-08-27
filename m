Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0H0T1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 15:27:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61086 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab0H0T1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 15:27:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [RFC PATCH 02/43] ptrace: cleanup ptrace_request()
Date: Fri, 27 Aug 2010 21:26:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35+; KDE/4.5.0; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com> <201008271623.01761.arnd@arndb.de> <87sk20f2z4.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
In-Reply-To: <87sk20f2z4.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008272126.56786.arnd@arndb.de>
X-Provags-ID: V02:K0:HR50NiMIqH/rJ9PQ7/teoZ0zc/yLrSE2BqVoXEOT6F0
 Xjb7MzXKqA7fCd5TRGhcAr0wumH5TArx4/rgqo+AFPHBYJ7jlj
 QH1LRTcTpIBlBrRvkkvE6poAicDkg9mVvSbnUVu0EXCrkj63ei
 sSXdZRWjVMal8es/mppuZJ28tO8tXUsFWUKvT28Yc9MswehLPh
 ikKjnXpCb2EVYWROcg8tg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 August 2010 18:13:35 Namhyung Kim wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> > If you introduce two pointers, 'siginfo_t __user *usiginfo' and
> > 'unsigned long __user *datap' instead of just 'datap', you can use
> > get_user/put_user everywhere, which would make the code better readable
> > and faster.
> >
> > Otherwise this change looks good.
> >
> 
> Despite I don't know how much it can run faster, I just want to keep it as is
> unless it would be a serious mistake. :-)

No, not a mistake, your code is fine as it is and not performance
critical at all.

However, in general using get_user/put_user is preferred over
copy_from_user/copy_to_user for scalar values.

	Arnd
