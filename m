Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1FEOhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 10:37:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64190 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1FEOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 10:37:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lqtDJTrYvO6yJkG2ixlzejLFXPo9UfroKylgEB1B7FrcoAXn25eFhwCESr1H/elIZX
         aY5O4hS66g5grpi63cLb0d+T4aqeialS12q9ilIDJHkdiELzqjftf/T3fHHhwA0dr20P
         G+qQwS/Ew+uQ6Bz6BZu4LT9xzaJWu9DyXyvSc=
MIME-Version: 1.0
In-Reply-To: <BANLkTim6VsynZHLagcu9Xo3EjsUz=54dYA@mail.gmail.com>
References: <1306999045.29297.55.camel@pasglop>
	<1307003821.29297.77.camel@pasglop>
	<20110602110727.7343782b@lxorguk.ukuu.org.uk>
	<1307062574.29297.204.camel@pasglop>
	<1307081874.23876.14.camel@pasglop>
	<1307084189.23876.19.camel@pasglop>
	<BANLkTim6VsynZHLagcu9Xo3EjsUz=54dYA@mail.gmail.com>
Date: Sun, 5 Jun 2011 16:37:40 +0200
Message-ID: <BANLkTikJJfyo-eExZYN4iZUO+RrkgPmX4A@mail.gmail.com>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
From: Guillaume Chazarain <guichaz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 11:36 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Otherwise we'll need to just revert it. The commit is clearly totally broken.

Even after the revert in http://git.kernel.org/linus/55db4c6 I can
reproduce some pty oddities using the test program in
http://lkml.org/lkml/2005/2/14/212.

Instead of having the output being different from the input, the child
process hangs reading while the parent is done writing.

The hangs should be easily seen with:

$ while :; do date; yes | head -n 5000 | ./a.out > /dev/null; done

-- 
Guillaume
