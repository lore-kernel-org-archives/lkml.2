Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab1ITGZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 02:25:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39086 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1ITGZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 02:25:47 -0400
Date: Mon, 19 Sep 2011 23:26:02 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 1/5] lib: add unpack_hex_byte()
Message-Id: <20110919232602.ac450450.akpm00@gmail.com>
In-Reply-To: <CAHp75VefX=KUGarhc9QK41AN6_MbxkrGWMHk7_40g0TMcLhgzg@mail.gmail.com>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
	<20110919141911.e13569ab.akpm@google.com>
	<1316471708.3191.130.camel@localhost.localdomain>
	<20110919153810.ba0be83a.akpm@google.com>
	<CAHp75VefX=KUGarhc9QK41AN6_MbxkrGWMHk7_40g0TMcLhgzg@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011 09:04:00 +0300 Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Tue, Sep 20, 2011 at 1:38 AM, Andrew Morton <akpm@google.com> wrote:
> >> > Finally, the name is poor. __It starts with "unpack_", so it belongs to
> >> > the "unpack" subsystem. __There's no such thing. __Something like
> >> > hex_byte_to_bin() would be better.
> >>
> >> agreed. __It was suppose to parallel the existing pack_hex_byte().
> >
> > hex_byte_pack() :)
> Have you just proposed to do mass rename of pack_hex_byte() to the
> hex_byte_pack()?

It's very minor, but I suppose we should, if someone feels like it.

We should retain a

char * __deprecated pack_hex_byte(char *buf, u8 byte)
{
	return hex_byte_pack(buf, byte);
}

for a few cycles to minimise harm to out-of-tree code.
