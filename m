Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0DLGYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:24:32 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35579 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0DLGYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=uKBwL2ALoBxi8VwclNVqwqJEd87b7OYdgtn/x5Rpq95uZ2HnPgLqhI9JsgnoyBr2t4
         dC2DctqpGdkBk4MOC/ZDHDma6PPHPS6HTrYmPfvGSoLqtYbbCOnFT1wOv4/lDNl7+XlD
         iqelL9yX25rvecR8KPZFU5Lqwh8ySK5g11yGw=
MIME-Version: 1.0
In-Reply-To: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 12 Apr 2010 02:24:09 -0400
Message-ID: <n2i8bd0f97a1004112324g833510adr92bfd195051b882@mail.gmail.com>
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
To: David VomLehn <dvomlehn@cisco.com>
Cc: to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, maint_arch@dvomlehn-lnx2.corp.sa.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 02:06, David VomLehn wrote:
> This patch makes panic() and die() registers available to, for example,
> panic notifier functions.  Panic notifier functions are quite useful
> for recording crash information, but they don't get passed the register
> values. This makes it hard to print register contents, do stack
> backtraces, etc. The changes in this patch save the register state when
> panic() is called and introduce a function for die() to call that allows
> it to pass in the registers it was passed.
>
> Following this patch are more patches, one per architecture. These include
> two types of changes:
> o  A save_ptregs() function for the processor. I've taken a whack at
>   doing this for all of the processors. I have tested x86 and MIPS
>   versions. I was able to find cross compilers for ARM, ... and the
>   code compiles cleanly. Everything else, well, what you see is sheer
>   fantasy. You are welcome to chortle with merriment.

could you post a sample module that you're using to test with here ?
presumably you have some simple code that registers a notify handler
and then calls panic_with_regs() ...
-mike
