Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab1LGSBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:01:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50384 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab1LGSBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:01:21 -0500
Message-ID: <4EDFA9D6.5050907@zytor.com>
Date: Wed, 07 Dec 2011 10:00:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Brian Gerst <brgerst@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Blechmann <tim@klingt.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [20/80] ALSA: lx6464es - fix device communication via command
 bus
References: <20111207161256.GA7736@kroah.com> <20111207160824.268488820@clark.kroah.org> <CA+55aFwzdXwLJjUL_i247exawkzqdoCULXg81qzG4Ewn7ysn3A@mail.gmail.com>
In-Reply-To: <CA+55aFwzdXwLJjUL_i247exawkzqdoCULXg81qzG4Ewn7ysn3A@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 09:47 AM, Linus Torvalds wrote:
> 
> Ingo, Peter, Thomas? Comments?
> 

I agree in principle, although I am really not happy about the idea of
disallowing 64-bit writes from device drivers that haven't explicitly
indicated they won't support it.

However, I would *also* like if more drivers would explicitly specify
the transfer size they expect.  Right now, that is done though a set of
functions whose name are a bit of a mismatch to the others:
__iowrite{32,64}_copy(), which probably should be renamed
memcpy_toio{32,64}() and augmented with matching memcpy_fromio{32,64}()
functions.

What do you think?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

