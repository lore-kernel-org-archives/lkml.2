Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0EQOL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:11:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42887 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0EQOLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=leyQrj+r3LYOhly9oIqAW6cukLoKUPX3d3+K5/W4j6a3FOXTpcyAQ1D5YI7o49QWjM
         CwWqi1JEKCuVzNBFXnMrUc7zdnf/SV9TcO/flrViDmbucxBC026o6fxG4nYaZqiMgY8n
         yWHqvZ1MicgCxkWazO3KVQQPjIZo4ndQ+V130=
MIME-Version: 1.0
In-Reply-To: <20100517070440.13d193aa@infradead.org>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	 <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
	 <1273540344.3843.101.camel@localhost.localdomain>
	 <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
	 <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
	 <1273697523.2856.3.camel@localhost.localdomain>
	 <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
	 <alpine.LFD.2.00.1005170123090.3368@localhost.localdomain>
	 <AANLkTinFlyz2d4Y6Viw0aWfe6mb6F7Ev4UCvkkQVFADd@mail.gmail.com>
	 <20100517070440.13d193aa@infradead.org>
Date: Mon, 17 May 2010 10:11:51 -0400
Message-ID: <AANLkTin3tcYAsXVVEdhfPG0YJRYO6gcO-gCl1rlf6XNG@mail.gmail.com>
Subject: Re: PROBLEM: tickless scheduling
From: Donald Allen <donaldcallen@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 10:04 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 17 May 2010 09:44:47 -0400
> Donald Allen <donaldcallen@gmail.com> wrote:
>
>> I will do the experiment suggested by Arjan van de Ven and report the
>> results of that separately.

Just for my own information, is this correct:

I assume that tickless scheduling, rather than relying on periodic
clock interrupts to wake up the scheduler, relies on interrupt
handlers to somehow signal the system that the scheduler needs to run
because they've just processed an event that has changed the state of
the system?

If so, then it looks like using the msi-style device-specific
interrupts isn't working reliably on this hardware? Or somehow the
kernel (or a driver) is failing to handle the interrupts properly with
msi enabled on certain hardware? I mention the latter only because of
the report yesterday from someone else seeing the same symptoms I am
on completely different hardware.

/Don

>
>
> since you're losing interrupts.. another good option to try is "irqpoll"
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
