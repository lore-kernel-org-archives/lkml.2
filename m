Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab2IDKjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 06:39:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64000 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab2IDKjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 06:39:11 -0400
Date: Tue, 4 Sep 2012 12:39:05 +0200
From: Julian Andres Klode <jak@jak-linux.org>
To: Manavendra Nath Manav <mnm.kernel@gmail.com>
Cc: kernelnewbies@kernelnewbies.org, devel@driverdev.osuosl.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Why exported const value modified by another driver not updated
 in original driver
Message-ID: <20120904103905.GA21953@jak-linux.org>
References: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
 <CAJKgH8CNJM2SyR7bD8nXae13-Fq1MP1Xn7+383YU-HPwKBe+Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKgH8CNJM2SyR7bD8nXae13-Fq1MP1Xn7+383YU-HPwKBe+Zg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:58:20PM +0530, Manavendra Nath Manav wrote:
> On Tue, Sep 4, 2012 at 3:00 PM, Manavendra Nath Manav
> <mnm.kernel@gmail.com> wrote:
> > Hi,
> >
> > I have declared a static const int variable in one driver and exported
> > that variable symbol. In another driver i am modifying that variable.

No, you did not export it. It's static (and static is kind of the opposite
of extern). And then you try to assign a value to a non-static variable with
the same name, which might not even exist (as the other is static, this should
not even work in my opinion).

> > The other driver prints the modified value but the original driver
> > retains the original value. When both virtual and physical addresses
> > of the variable as seen by both drivers are same, how is this even
> > possible. Is it a kernel bug?

It only works because the compiler optimized the value = 123 away,
and replaced value with 123 in the first module everywhere, as it
is declared const and thus cannot be changed, so there's no reason
to read it from memory.

-- 
Julian Andres Klode  - Debian Developer, Ubuntu Member

See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.
