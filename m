Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab0EFNgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 09:36:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61872 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab0EFNgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 09:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VDm8Hafb8Yw7Cdhk/aPl66ISwB1fQF3wNi2K/af+4rimsswA+sQeHhWkke+6oKsS+0
         Ge8LmqCtQ4W+8WUwUMErcZ8KGK4CUyglMPXFe8rwaBaROoePan0dV5aq8UVGPRuxhP1C
         afsh4TfOq36/YVHF3AII09k0G6+cw/yjs+zos=
MIME-Version: 1.0
In-Reply-To: <1273151844.23208.48.camel@mulgrave.site>
References: <1273096160.23208.35.camel@mulgrave.site>
	 <p2x10f740e81005052347x9430657fua98b8982e860bd2d@mail.gmail.com>
	 <1273151844.23208.48.camel@mulgrave.site>
Date: Thu, 6 May 2010 15:36:31 +0200
X-Google-Sender-Auth: c0eff55d107477fe
Message-ID: <y2j10f740e81005060636ra458212bt4352ca0b6b7df7fe@mail.gmail.com>
Subject: Re: kbuild: fixing the select problem
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-arch@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 15:17, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2010-05-06 at 08:47 +0200, Geert Uytterhoeven wrote:
>> On Wed, May 5, 2010 at 23:49, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > [Sam: I know you don't maintain kbuild anymore, but since you have the
>> > most experience, if you could find time to comment, I'd be grateful]
>> >
>> > The select problem is that the kbuild select directive will turn a
>> > symbol on without reference to its dependencies.  This, in turn, means
>> > that either selected symbols must select their dependencies, or that
>> > people using select have to be aware of the selected symbol's dependency
>> > and build those dependencies into their symbol (leading to duplication
>> > and the possibility of getting the dependencies out of sync).  We use
>> > select for the scsi transport classes, so we run into this problem in
>> > SCSI quite a lot.
>> >
>> > I think the correct fix is to make a symbol that selects another symbol
>> > automatically inherit all of the selected symbol's dependencies.
>>
>> What if there's a good reason the selected symbol has this dependency?
>> E.g. it depends on a critical feature not available? Like CONFIG_HAS_IOMEM?
>
> I don't quite understand the question.  If a selected symbol has a
> critical dependency which is config'd to N then the build usually
> breaks ... that's what I'm calling the select problem.  I thought
> CONFIG_HAS_IOMEM was usually selected by the architecture, though.  In
> the new proposal, we wouldn't be able to generate the invalid
> configuration in the first place.

Sorry, my fault, -EREPLY_TOO_EARLY_AFTER_WAKEUP.
Upon rereading what you actually wrote, it made complete sense, and my
question didn't.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
