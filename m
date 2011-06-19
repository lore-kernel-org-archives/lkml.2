Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1FSWKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 18:10:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49032 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1FSWK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 18:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JkmCQ62u46TFt4b8TgtYJErJCZDf/Dfn6/z2Valc4IjwifWSxYRCLqY0sZoLozytBx
         HzIlhra5qh+m7lNkOh2DPTmc571bD+vrB2uk5rKAo+jfZR0GkGjQK4NuC0nvzaUbf/bU
         ikf+/CDXDTs8YBRjrZidfFdgZKgY90pLwo+Ho=
MIME-Version: 1.0
In-Reply-To: <1308470447.3539.66.camel@edumazet-laptop>
References: <BANLkTik3iseHFah_s=NNasQ22NtA+9zLWA@mail.gmail.com>
	<1308470447.3539.66.camel@edumazet-laptop>
Date: Sun, 19 Jun 2011 17:10:28 -0500
Message-ID: <BANLkTik_9p+6CA_+A91CNH+KuskH3sh72w@mail.gmail.com>
Subject: Re: tracing kernel panics
From: Shane <software.research.development@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It seems you have bugs in your module, maybe something like freeing
> memory twice, or memory you dont own, or manipulating some data without
> taking the associated lock protecting it.
>
> tcp sockets are protected by RCU and various locks, getting them used
> right is not an easy task.
>

All very helpful comments. I'm interested in how you guys came to the
conclusion that I was doing these things wrong. Not that I don't deny
it, but I'm trying to learn the *how* of getting to the source of a
problem without asking what am I doing wrong.

For example, is there anyplace that tells how to use TCP sockets
correctly in relation to the various locks? Best I can tell, I'm doing
exactly as is in the kernel sources under /net. I'm still trying to
understand when to use a lock when manipulating data, or what type of
data needs a lock.

What scares me (because I'm spending so much time on it) is that some
of these panics seem to be coming from the VM and I may be chasing
something that is the effect rather than the cause, and therefore not
seeing/catching the real panic. Or maybe I have all the info I need,
but just confused on how to read it.
