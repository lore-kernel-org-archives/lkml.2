Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab2FOKc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:32:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33263 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab2FOKcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120614161331.GA29687@redhat.com>
References: <20120614161331.GA29687@redhat.com>
Date: Fri, 15 Jun 2012 18:32:54 +0800
Message-ID: <CAM_iQpV4WOSafe8X9pjV++CUJyb30VDOVVKOiusA9OxGyj6CTw@mail.gmail.com>
Subject: Re: 3.5.rc2 tty buffering bug ?
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 12:13 AM, Dave Jones <davej@redhat.com> wrote:
> but when redirected to a file, sometimes it prints what we expect, but other times
> (if the child exits first) it seems to print..
>
> begin
> child
> end
> begin
> parent
> end
>
>
> How does 'begin' get printed a second time ?
>

setbuf(3) said:

"
Normally  all files are block buffered. [...]
If a stream refers to a terminal (as stdout normally does) it is line buffered.
The standard error stream stderr is always unbuffered by default.
"
So when you redirect stdout to a file, "begin\n" is buffered too, both
in child and in parent.
