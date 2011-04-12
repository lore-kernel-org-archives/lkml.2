Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab1DLJpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:45:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42773 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1DLJpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:45:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sRGNj1/CA7APzQXg6UpUrulcdMJiN+X8JhiC30KLNoPz/0lRmHH1h9i7SEj7OFBGQP
         B18fk8FeqsCmlMi3ZH21I/Jac0IZVZl7yzuEplT2vBiRfW6lEJliCC0+84rrfqXSD5sy
         VMd2NJcgvGvoz0oGOh9TFZ+g37FfL3Fe3N8A8=
MIME-Version: 1.0
In-Reply-To: <1302575869.13492.1440076201@webmail.messagingengine.com>
References: <1302575869.13492.1440076201@webmail.messagingengine.com>
Date: Tue, 12 Apr 2011 10:45:19 +0100
Message-ID: <BANLkTi=jpdLRc35DkBhLmUr8-P+ggcrgoA@mail.gmail.com>
Subject: Re: Loopback and Nagle's algorithm
From: Will Newton <will.newton@gmail.com>
To: Adam McLaurin <lkml@irotas.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 3:37 AM, Adam McLaurin <lkml@irotas.net> wrote:
> I understand that disabling Nagle's algorithm via TCP_NODELAY will
> generally degrade throughput. However, in my scenario (150 byte
> messages, sending as fast as possible), the actual throughput penalty
> over the network is marginal (maybe 10% at most).
>
> However, when I disable Nagle's algorithm when connecting over loopback,
> the performance hit is *huge* - 10x reduction in throughput.
>
> The question is, why is disabling Nagle's algorithm on loopback so much
> worse w.r.t. throughput? Is there anything I can do to reduce the
> incurred throughput penalty?

It may be caused by an increase in context switch rate, as both sender
and receiver are on the same machine.
