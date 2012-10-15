Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2JOXmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:42:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33662 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab2JOXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:42:52 -0400
MIME-Version: 1.0
In-Reply-To: <1350343478.4523.7.camel@air.home.fifi.org>
References: <7i391fto34.fsf@lanthane.pps.jussieu.fr>
	<20121015231302.GF2739@dastard>
	<1350343478.4523.7.camel@air.home.fifi.org>
Date: Tue, 16 Oct 2012 03:42:52 +0400
Message-ID: <CAMo8BfLp2e_sO=3-++TkjxiUm_syTuxndj5H37YLddYqk-54tg@mail.gmail.com>
Subject: Re: Write is not atomic?
From: Max Filippov <jcmvbkbc@gmail.com>
To: Philippe Troin <phil@fifi.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Juliusz Chroboczek <jch@pps.jussieu.fr>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 3:24 AM, Philippe Troin <phil@fifi.org> wrote:
> On Tue, 2012-10-16 at 10:13 +1100, Dave Chinner wrote:
>> On Mon, Oct 15, 2012 at 11:36:15PM +0200, Juliusz Chroboczek wrote:
>> > The following fragment of code
>> >
>> >     int fd;
>> >     fd = open("exemple", O_CREAT | O_WRONLY | O_TRUNC, 0666);
>> >     fork();
>> >     write(fd, "Ouille", 6);
>> >     close(fd);
>
> can be replaced with:
>
>         int fd;
>         fd = open("exemple", O_CREAT | O_WRONLY | O_TRUNC | O_APPEND, 0666);
>         fork();
>         write(fd, "Ouille", 6);
>         close(fd);

Fails the same way as the original. I guess O_APPEND doesn't work this way
for writes to the shared file descriptor.

-- 
Thanks.
-- Max
