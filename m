Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2IDK7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 06:59:49 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64837 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2IDK7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 06:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120904103905.GA21953@jak-linux.org>
References: <CAJKgH8Ah-aq=LfOWs2SBZnndzugNGxJbqYS11YVQLXJy6FZxkw@mail.gmail.com>
 <CAJKgH8CNJM2SyR7bD8nXae13-Fq1MP1Xn7+383YU-HPwKBe+Zg@mail.gmail.com> <20120904103905.GA21953@jak-linux.org>
From: Manavendra Nath Manav <mnm.kernel@gmail.com>
Date: Tue, 4 Sep 2012 16:29:27 +0530
Message-ID: <CAJKgH8BYe7oS5opyiX0NL7Qj3CreEiRBD4xWoORhLAVWaqMe-A@mail.gmail.com>
Subject: Re: Why exported const value modified by another driver not updated
 in original driver
To: Julian Andres Klode <jak@jak-linux.org>
Cc: kernelnewbies@kernelnewbies.org, devel@driverdev.osuosl.org,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 4:09 PM, Julian Andres Klode <jak@jak-linux.org> wrote:
> On Tue, Sep 04, 2012 at 03:58:20PM +0530, Manavendra Nath Manav wrote:
>> On Tue, Sep 4, 2012 at 3:00 PM, Manavendra Nath Manav
>> <mnm.kernel@gmail.com> wrote:
>> > Hi,
>> >
>> > I have declared a static const int variable in one driver and exported
>> > that variable symbol. In another driver i am modifying that variable.
>
> No, you did not export it. It's static (and static is kind of the opposite
> of extern). And then you try to assign a value to a non-static variable with
> the same name, which might not even exist (as the other is static, this should
> not even work in my opinion).
>
>> > The other driver prints the modified value but the original driver
>> > retains the original value. When both virtual and physical addresses
>> > of the variable as seen by both drivers are same, how is this even
>> > possible. Is it a kernel bug?
>
> It only works because the compiler optimized the value = 123 away,
> and replaced value with 123 in the first module everywhere, as it
> is declared const and thus cannot be changed, so there's no reason
> to read it from memory.
>
> --
> Julian Andres Klode  - Debian Developer, Ubuntu Member
>
> See http://wiki.debian.org/JulianAndresKlode and http://jak-linux.org/.

Still I am not able to understand !! Why the output behaviour changes
when the declaration is made as "const volatile". I get the same
results as above when i remove "static" and retain "const".
-- 
Manavendra Nath Manav
