Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0KHHMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:12:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45692 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab0KHHMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:12:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PZySHhi79HyD/5drgOyI7f9OEfJB0+aNnMHnduRHOOSxCjoKJvE67y6G0wERhZqaxB
         mUr+jeykiht/v+Aa3paJY6d4HDYxD7/3UI63IpReskwIJaWdShPUf0sLmAiL5HphMlxk
         rFzvDdQkU7lzybbFa+4kM2qtfPbTN22xlpnF0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=40758wF4Z6GDfm809miA-hnCnSQdwA9bALX0+@mail.gmail.com>
References: <AANLkTi=40758wF4Z6GDfm809miA-hnCnSQdwA9bALX0+@mail.gmail.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Mon, 8 Nov 2010 15:12:00 +0800
Message-ID: <AANLkTim_qtAO-muZk4q9N=_DFsvAcQprnLDx7XOe3aNg@mail.gmail.com>
Subject: Re: how to read one udp packet with more than one recvfrom() calls?
To: ranjith kumar <ranjithproxy@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 3:08 PM, ranjith kumar <ranjithproxy@gmail.com> wrote:
> Hi,
>
> I  have implemented client and server programs using udp
> protocol(files are attached).
> UDP packet size is 500bytes.
>
> I want to read these 500bytes in two calls to recvfrom(). First time
> reading 100bytes and second time 400bytes.
> How to do this?
>
> When I tried to change the third argument of recvfrom(size_t len),
> from 500 to 100, first 100bytes are read correctly.
> But when I call recvfrom() second time with len=400, it is reading the
> first 400bytes of "next udp packet".
> Why? Isn't it possible to read one udp packet in two calls to
> recvfrom()/read()????
>

recvmsg(2):

       MSG_PEEK
              This  flag  causes the receive operation to return data from the
              beginning of the receive queue without removing that  data  from
              the queue.  Thus, a subsequent receive call will return the same
              data.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
