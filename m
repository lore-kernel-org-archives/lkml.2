Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0KKQXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:23:31 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38238 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0KKQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=T8KiPJH3vpvphgwpZ1QXihTmtTboFu2KnJOV/4mszsqcpqbn3SYk856NzfqT6jbsyA
         TcSXjJYVLuzayy9WEieW76sWrTJjXkHvouavKBzPYx16WkhBvNloWjQ7QrXxyl4l8QfX
         L64UFGwK1jOPo2o6Agk80yditW9XiGfQY9X1w=
MIME-Version: 1.0
In-Reply-To: <4CC5DF22.6020203@nolaviz.org>
References: <1287859409-13810-1-git-send-email-alon-git@nolaviz.org>
	<1287859409-13810-3-git-send-email-alon-git@nolaviz.org>
	<20101025111126.GA4046@localhost>
	<4CC5DF22.6020203@nolaviz.org>
Date: Thu, 11 Nov 2010 17:23:29 +0100
Message-ID: <AANLkTikWLBr7WOd9K9WqFSvYTfoUdrQ3R+qdyMaVZWf_@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] opticon: use generic code where possible
From: Johan Hovold <jhovold@gmail.com>
To: Alon Ziv <alon@nolaviz.org>
Cc: Alon Ziv <alon+git@nolaviz.org>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 9:48 PM, Alon Ziv <alon@nolaviz.org> wrote:
>> Here it seems you're turning write into a blocking function if you have
>> no bulk-out end-point. I'm not sure that is desired.
>
> Right...
> I considered doing it differently (which would require more code--I
> would need to track the outstanding control URBs, and would need a
> callback to free the kmalloc()ed setup packet). In the end, I left it as
> blocking because the actual protocol used by the OPN2001 is very light
> on writes (in fact, it never writes anything without waiting for a
> response, and its longest outgoing message is
> limited to 70 bytes).

But you already had a working non-blocking implementation in place
(authored by yourself, if I'm not mistaken) which did exactly that.
Why not simply keep it?

Thanks,
Johan
