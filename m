Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0EJAAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 20:00:54 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45812 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0EJAAw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 20:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IPJXgUIzP69xMXnmG2mC4mQTM8HaBlYoaGOISwwP9LrR0ya19/jkdbjfpC9IaAN5IN
         fN1tv+pS9HcssdB7zyErUFv42Y+KmrCRZMVmPU+OOMui1es1eAL6wzHAElkGvGF2s86Q
         NZDDXx/c0afvt0osoYl69uFI0eb7aeN26jWAo=
MIME-Version: 1.0
In-Reply-To: <20100509184911.3f136b77@neptune.home>
References: <20100509184911.3f136b77@neptune.home>
Date: Mon, 10 May 2010 08:00:51 +0800
Message-ID: <AANLkTik0EkPYKdnhrpF7yK6eXIrHMsNYrzSC6tyeBR0P@mail.gmail.com>
Subject: Re: Deadlock between fbcon and fb_defio?
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 12:49 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
>
> Fix crash if we are the first framebuffer loaded as in that case fbcon
> wants to flush framebuffer at the end of fb registration, before we
> have setup fb_defio.

Bruno,

Please help me understand, how does this scenario occur? I'm
interpreting what you've written above to mean that fbcon is accessing
the framebuffer before you've called defio_init()? Is that correct?

The typical defio use sequence is: defio_init(),
register_framebuffer() and the typical remove sequence is in the
reverse order unregister_framebuffer(), defio_cleanup(). So, I don't
see how fbcon is accessing the framebuffer either before
register_framebuffer() completes (at which point defio init is already
done) or after unregister_framebuffer() completes.

Thanks,
jaya
