Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab1EXUq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:46:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60587 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1EXUqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:46:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ns79DI/hItWACqq5gN2Lyzh2K1zzHhUa7ci7OaLY61+0LLoKlkbQlkLIKYbm/7kpsz
         YiVeaJYlDCu37V9O5jzlz8UdpipMjpZdc6usE1Mk0pSf452xdy1iANORS0ZxZn+8qMkN
         Db/iz9pQoGDhkpEwwcwfzA2vZSsQWNWLGXc3U=
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
From: Hiromu Yakura <hiromu1996@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, zippel@linux-m68k.org
In-Reply-To: <BANLkTikFT17GOgV1UJTFxEG+P2X-u4ZJjw@mail.gmail.com>
References: <1306167401.18840.8.camel@hiromu-MacBook>
	 <BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com>
	 <1306242400.7501.10.camel@hiromu-MacBook> <4DDBB150.2090602@suse.cz>
	 <1306247192.7501.25.camel@hiromu-MacBook> <4DDBC846.8050402@suse.cz>
	 <BANLkTin5ZDt5ZeckOJ2WsNUZm6mxmYiRwQ@mail.gmail.com>
	 <1306258716.7501.35.camel@hiromu-MacBook>
	 <BANLkTikFT17GOgV1UJTFxEG+P2X-u4ZJjw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 05:46:50 +0900
Message-ID: <1306270010.7501.43.camel@hiromu-MacBook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011, at 2:59, Arnaud Lacombe <lacombar@gmail.com>
wrote:
> Hi,
> 
> On Tue, May 24, 2011 at 1:38 PM, Hiromu Yakura <hiromu1996@gmail.com> wrote:
> > On Tue, May 24, 2011, at 0:50, Arnaud Lacombe <lacombar@gmail.com>
> > wrote:
> >> On Tue, May 24, 2011 at 11:01 AM, Michal Marek <mmarek@suse.cz> wrote:
> >> > I see, qconf lacks a check for the return value of conf_write() in
> >> > ConfigMainWindow::closeEvent(), gconf does check the return value, but only
> >> > displays it in the bottom box of the main window instead of a message box.
> >> > Neither of them return failure in the error case. These bugs should be
> >> > indeed fixed.
> >> >
> >> agree.
> >>
> >> > But I don't like the directory permission check, it only
> >> > handles one case, but does not handle permission on the .config file itself
> >> > with KCONFIG_OVERWRITECONFIG=1, ENOSPC and so on.
> >> >
> >> seconded.
> > I'm sorry for forgetting to handle a case which was set KCONFIG_OVERWRITECONFIG.
> > So I rewrote the patch and attach it.
> >
> > Thanks for your advice.
> >
> > Signed-off-by: Hiromu Yakura <hiromu1996@gmail.com>
> >
> Let me re-state: your patch does not handle all the case where
> conf_write() may fails, and I do not think we want to preemptively
> check for all errors open(2) may return.
conf_write() is called after the configure changed.
So I don't think we should handle the failed case of conf_write()
because the purpose of this patch is not to losing changes.


