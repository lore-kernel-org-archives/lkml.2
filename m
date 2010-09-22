Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0IVXwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 19:52:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51260 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0IVXwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z4LzV7ia5FkTItVanEQVEYwYzAP+xWLQkWmhY+/fw7i8IDb/A3xG9kVgAzJ/E2zXG1
         mD4/4pcnvT9pD/MlQe8m0rcImJa9x0K9s0XpWAMpqkhGGE4vXSNbE86Vgzdfc4tc7YKh
         blauT6fzNdsYOboaiuukBbcE4tjAJQFytdDPc=
MIME-Version: 1.0
In-Reply-To: <20100920223700.GA20507@laptop.local>
References: <20100920223700.GA20507@laptop.local>
Date: Wed, 22 Sep 2010 16:52:17 -0700
Message-ID: <AANLkTimFyorLPWv4px8_7KQRu_L8Ezftdb=0mXAOm76K@mail.gmail.com>
Subject: Re: dm-crypt and huge performance penalty
From: Ryan Castellucci <ryan.castellucci@gmail.com>
To: Dmitry Nezhevenko <dion@inhex.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 3:37 PM, Dmitry Nezhevenko <dion@inhex.net> wrote:
> Firstly I've tried to setup raid5 and then dm-crypt on top of it. After
> discovering issue I've tried just raid5 and confirmed that mdadm itself
> works as expected.
>
> And the last idea is to setup three dm-crypt partitions and then raid5 on
> top of independently encrypted drives.
>
> So here are my results:
>
>           |  mdadm   | mdadm+dm-crypt | 3 x dm-crypt + mdadm |
> Seq. read  | 168 Mb/s | 57 Mb/s        | 119 Mb/s             |
> Seq. write | 80 Mb/s  | 36 Mb/s        | 64.4 Mb/s            |

dm-crypt will only use one core per device, so this is expected
behavior (and I believe an issue that is being worked on). From these
numbers it looks like you have a dual core or dual cpu system?

-- 
Ryan Castellucci http://ryanc.org/
