Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1CVDJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 23:09:40 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42555 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1CVDJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 23:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ap0OvIIZ4DoOMa6DrJpnK6fnYUVfLy0XTUn/e+Z1jUW33VQRHinelTnmNROH6qt6Hi
         PgDhDOjwPWUTDcQwyZYXE8Y0jnzAfFR5vzvofFL4k0bFfyTIEZjBm3qh8LkSPPZVx3V7
         sBZpGSmEkJg/cDnH1KJxM/MQIXXaR3Kwdm3ao=
MIME-Version: 1.0
In-Reply-To: <1300763079.1483.21.camel@leonhard>
References: <1300452855-10194-1-git-send-email-namhyung@gmail.com>
	<1300452855-10194-3-git-send-email-namhyung@gmail.com>
	<20110322085938.0691f7f4.kamezawa.hiroyu@jp.fujitsu.com>
	<1300763079.1483.21.camel@leonhard>
Date: Tue, 22 Mar 2011 08:39:35 +0530
X-Google-Sender-Auth: mZC-etN9UUO6fVzjAlCs1AiZDTA
Message-ID: <AANLkTik7r3naRV6gFfN7+sLAbgAoiMkXwKUwY6nV5FH+@mail.gmail.com>
Subject: Re: [PATCH 3/3] memcg: move page-freeing code outside of lock
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 8:34 AM, Namhyung Kim <namhyung@gmail.com> wrote:
>
> 2011-03-22 (화), 08:59 +0900, KAMEZAWA Hiroyuki:
> > On Fri, 18 Mar 2011 21:54:15 +0900
> > Namhyung Kim <namhyung@gmail.com> wrote:
> >
> > > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > What is the benefit of this patch ?
> >
> > -Kame
> >
>
> Oh, I just thought generally it'd better call such a (potentially)
> costly function outside of locks and it could reduce few of theoretical
> contentions between swapons and/or offs. If it doesn't help any
> realistic cases I don't mind discarding it.

swapoff is a rare path, I would not worry about it too much at all.

Balbir
