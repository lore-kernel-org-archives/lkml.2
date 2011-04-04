Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1DDDTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 23:19:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35855 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab1DDDTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 23:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=EprJIRCRQ7t6v0dAO3ZmBvMXCbkPy2zagEv/x6hvjzvqyHvb9GqKfgoA6l3ZgJPqqO
         JoJ7ZcuE7nFzl6qlmzwZps893QbFzHHiDuLfuVfKNNjZWV7qo5MvEvVGRJN1D/r8hPpa
         9hJIvxONgMZPGE8CAAUiFYIwxEMzH3lHJKyT8=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=pS8Wk9Ymtj=DeVqfgqBsbTXDHZA@mail.gmail.com>
References: <BANLkTi=pS8Wk9Ymtj=DeVqfgqBsbTXDHZA@mail.gmail.com>
Date: Mon, 4 Apr 2011 11:19:08 +0800
Message-ID: <BANLkTi=Mu70wYSM0sVRWZnQzTPBOvqt6xg@mail.gmail.com>
Subject: Re: [2.6.39-rc1] LTP hitting max (8) nested links...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2011 11:13, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> When a test from the Linux Test Project [1] with 2.6.39-rc1 while
> trying to reproduce another fileystem issue, I quickly hit the 8
> nested link limit [2]:
> BUG_ON(nd->depth >= MAX_NESTED_LINKS)
>
> It seems a mutually exclusive condition to have such a technical limit
> in-kernel and a test in LTP which triggers that, unless there is a bug
> of course.
>
> Though 8 seems reasonable in most cases, it looks like an artificial
> and not technical limit which feels more broken - perhaps a WARN_ON or
> higher limit before BUG() is called makes sense?

Re-reading everything, nested here is actually recursively nested, not
consecutively nested, so will never succeed, so we expect this from
the LTP test.
-- 
Daniel J Blueman
