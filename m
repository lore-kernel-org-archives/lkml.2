Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab1DHSOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:14:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54357 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab1DHSOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=prYRxevu3YYcegs1f9LB+otDE8HcPGwzm4IWrfAT7KKP+k8zictEVEwqlAiUehRxrF
         lJ7aHwv2hb7h8lyGx2kYh5QVmgqB/ksqGNjeGhrxYzVy+6cyybZjsJQKXDHkBPzvVftZ
         a8M/hpHMj/L2OCSBUAaXFOLildc726N9d8BOo=
MIME-Version: 1.0
In-Reply-To: <4D6510A3.90905@aknet.ru>
References: <4D6510A3.90905@aknet.ru>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 8 Apr 2011 14:13:26 -0400
Message-ID: <BANLkTinfOKf+aSKy+Rj+2+v42JeGuzzrNg@mail.gmail.com>
Subject: Re: [path][rfc] add PR_DETACH prctl command
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 08:50, Stas Sergeev <stsp@aknet.ru> wrote:
> Hi.
>
> The attched patch adds the PR_DETACH prctl command.
> It is needed for those rare but unfortunate cases, where
> you can't daemonize your process before creating a thread.
> The effect of this command is similar to the fork() and then
> exit() on parent, except that:
> 1. PID does not change
> 2. Threads are not destroyed
>
> It would be nice to know what people think about such an
> approach.

I can't comment on the patch itself, but, if your application knows it
might have to daemonize after spinning up threads, why not simply
fork() immediately on startup, and have the parent simply wait forever
for either the child to die or for a daemonize signal from the child?
If done early enough it shouldn't tie up too much memory, and it
wouldn't require any of these invasive kernel changes. As an added
bonus, it's portable to all unixen :)
