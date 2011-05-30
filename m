Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab1E3UOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 16:14:47 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60216 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1E3UOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 16:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XWzwMUT0hz6idU/WCivbJWjZeq5jXC42OyTEpIPOtBssMGdnji6tp1m1nVpc8qMAWA
         CpADh02CYzOG3zTEg8/seMw0cAt7MA3btsiufyN1NIlp4V/EhT4zpCmzl3b72ze48iz7
         BEQR4ZM02+aAGZuiGp1RDHdMr2SbL5xyf0OMk=
MIME-Version: 1.0
In-Reply-To: <20110530161014.GS25813@smp.if.uj.edu.pl>
References: <20110530161014.GS25813@smp.if.uj.edu.pl>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 30 May 2011 16:14:26 -0400
X-Google-Sender-Auth: _AB9OdedtV5k2EZhHHJNvXRg4Gs
Message-ID: <BANLkTi=7k4XbK6JVDp3oOJRAK_7Ox=aWMw@mail.gmail.com>
Subject: Re: Kernel OOPS in function_graph_tracer due to the
 44259b1abfaa8bb819d25d41d71e8e33e25dd36a commit (x86-64: Move vread_tsc into
 a new file with sensible options)
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 12:10 PM, Witold Baryluk
<baryluk@smp.if.uj.edu.pl> wrote:
> Hi,
>
> I found yesterday a problem when booting system on Pentium-M, 32-bit.
>
> I got approximetly this
>
> [    2.459170] Testing tracer function_graph:
> [    2.466979] BUG: unable to handle kernel paging request at e421cc10

>
> Reverting commit 44259b1abfaa8bb819d25d41d71e8e33e25dd36a on top of current
> kernel make bug disapear.
>
> Disabling CONFIG_FUNCTION_GRAPH_TRACER also make bug dispear.
>

Of course, the most trivial of my patches was the one with the most
significant bug.  Can you try this fix:

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=89e1be50c68eb5e58b873dce87bbac627ee18d1f

--Andy
