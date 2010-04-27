Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab0D0RHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:07:18 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:37817 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab0D0RHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:07:16 -0400
MIME-Version: 1.0
In-Reply-To: <20100427154043.GA25860@tuxdriver.com>
References: <20100427112842.3eec02a1.sfr@canb.auug.org.au>
	 <20100427154043.GA25860@tuxdriver.com>
Date: Tue, 27 Apr 2010 10:07:12 -0700
Message-ID: <i2p446ae9281004271007h43f9949dw9848a7786a9c7be1@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the wireless tree
From: Steve deRosier <steve@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 8:40 AM, John W. Linville
<linville@tuxdriver.com> wrote:
>
> Right.  So in wireless-testing I did the includes in the other order
> (i.e. "deb_defs.h" first), but that is a bit ugly.  Any suggestions
> on alternatives?
>
> "#undef pr_fmt" just before the "#define pr_fmt(fmt)..." line in
> db_defs.h seems to eliminate the warning even with the more normal
> ordering of the #include lines.  I'm not familiar with the usage of
> pr_fmt -- will doing the above preserve the desired effect?

John,

I thought about that particular strategy (doing the #undef) instead of
the non-traditional include mess.  But not being familiar enough with
the pr_fmt stuff, I didn't want to do it.

My goal was to get the '#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt'
line in the deb_defs.h header so it was only in one place.  But to
build, that define must be before kernel.h gets included anywhere.
Hence the current mess.

I'm OK with the #undef strategy and moving the deb_defs.h include to a
better position if that's the correct way to do this.  Please let me
know if I have any action items on this.

- Steve
