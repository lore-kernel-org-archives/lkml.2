Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1KUDZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 22:25:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62770 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1KUDZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 22:25:47 -0500
MIME-Version: 1.0
In-Reply-To: <CALKntY135akw4khsrbVdk2L-YgF0aYsaHw6Lhf7n4gU6MTrZuQ@mail.gmail.com>
References: <CALKntY135akw4khsrbVdk2L-YgF0aYsaHw6Lhf7n4gU6MTrZuQ@mail.gmail.com>
Date: Mon, 21 Nov 2011 11:25:46 +0800
Message-ID: <CAM_iQpXPTheJU_+GKHkDu2b0WrV_4oJJbM+pWY3uprh6fX7cSw@mail.gmail.com>
Subject: Re: Running Application Inside Application
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Xin Tong <xerox.time.tech@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:18 AM, Xin Tong <xerox.time.tech@gmail.com> wrote:
> I have applications that do not install signal handlers I need it to
> install. Therefore, I am thinking about having a light-weight run-time
> to load the application ELF file and install the needed signal handler
> in the run-time ? Is this doable ? What if it is not ELF-encoded ?
>

If you want to exec*() to load the ELF, no, the signal handlers will be
cleared after exec*(), as the entire .text will be replaced by the new ELF file.

So, you probably have to parse and load the ELF file by yourself.
