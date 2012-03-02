Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2CBRxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:53:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47470 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2CBRxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:53:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.236.181.193 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
In-Reply-To: <4F4FE1FA.1040008@zytor.com>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
	<4F4BF11E.4090000@zytor.com>
	<CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
	<4F4C1F76.70403@zytor.com>
	<alpine.DEB.2.00.1202281927130.24649@be10.lrz>
	<4F4D1E6A.5000200@zytor.com>
	<CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
	<4F4E6B98.2090306@zytor.com>
	<CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com>
	<4F4EB0B9.2080906@zytor.com>
	<CAKL7Q7pq5BTax4odM5YuzR4TsoU5CV59341LziR9c=Yjnia4gQ@mail.gmail.com>
	<4F4EBF44.60208@zytor.com>
	<CAKL7Q7qBOe70D80wOqLnnPLQaaVWbb2KB5P5p252oyPS4YgD1Q@mail.gmail.com>
	<4F4EC19F.4050002@zytor.com>
	<CAKL7Q7rZyUNNP+jy5ajL2KSbC8S4LEQZWG3vuPVSvSOCd_ZGQg@mail.gmail.com>
	<CAKL7Q7q9r0mCoGWOFamHUG6ujfs=voyAZBZHChXVO34cjCbZbw@mail.gmail.com>
	<4F4FE1FA.1040008@zytor.com>
Date: Fri, 2 Mar 2012 18:53:09 +0100
Message-ID: <CAKL7Q7owDCs0=RyhY7gLpyYgOJ9gisdH=p2+qvZ043dDFMN76Q@mail.gmail.com>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/1 H. Peter Anvin <hpa@zytor.com>:
             ^^^^^^^^^^^^^
>
> Sorry, you can't put non-x86 code in arch/x86.  There are two way to
> distribute this kind of stuff into arch directories:
>
> 1. You can define an ARCH_ symbol which indicates that <asm/kbdleds.h> is
> available; otherwise use the fallback routine;
>
> 2. You can define it in a .c file as an actual function in the affected
> architectures (x86 and parisc here) and then define it as a weak symbol
> (grep for __weak) in the common code.
>
> If you don't want to bite off this distribution I can understand it
> (although it's not up to me, technically, since I'm not the maintainer of
> the vt subsystem) but if so leave this as an inline in a common place.
>
>        -hpa

I thought about your idea for separating the platform specific code in
another file. It will make the code more modular but at the end we're
talking about a single function that flips a single bit. I really
don't see any real benefit from defining it in a separate file. It
makes (from my point of view) reading the file just more difficult.
That's why I decided to return the platform specific code back where
it originally was and only modifiy the x86 code. So I can keep the
changes at minimum. I'll post the patch later today and cc the tty
maintainer. Thanks for the help and the ideas.
