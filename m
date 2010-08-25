Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0HYAfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:35:45 -0400
Received: from mail.perches.com ([173.55.12.10]:1326 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab0HYAfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:35:44 -0400
Subject: Re: [PATCH] lib: fix scnprintf() if @size is == 0
From: Joe Perches <joe@perches.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinfjGB_1CaWNQHynFWK5Tki9BJCW3oeOaY68py9@mail.gmail.com>
References: <1282692902-2981-1-git-send-email-xiaosuo@gmail.com>
	 <1282694621.25208.19.camel@Joe-Laptop>
	 <AANLkTinfjGB_1CaWNQHynFWK5Tki9BJCW3oeOaY68py9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 17:35:43 -0700
Message-ID: <1282696543.25208.29.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 08:10 +0800, Changli Gao wrote:
> On Wed, Aug 25, 2010 at 8:03 AM, Joe Perches <joe@perches.com> wrote:
> > Isn't simpler to check size at the beginning of the function?
> It is a rare case, so don't slow down the normal users.

That's fine, but I don't like blinking that much
when I read code.

How about:

	if (i < size)
		return i;
	if (size)
		return i - 1;
	return 0;

