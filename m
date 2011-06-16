Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab1FPOYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:24:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40580 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab1FPOYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=HIK/sbtPtXGpzbhj9kzzV3RuJC+USNufW6vZC0HPjOyoXfhyO0eZlOcxfkdfT9MkEM
         38ItsKvwmqIKXlfLKZjAxGnbGsyRnQCjSi0QUOWGv/c59ygqstgL6T15CnusfBhYfjxM
         zB8slKFjM9z4j4cPHzq4BclScgpWA3zc8DRmc=
MIME-Version: 1.0
Date: Thu, 16 Jun 2011 10:24:44 -0400
X-Google-Sender-Auth: Ouu-qr45nkuaSjE56Jk8ImVTnMk
Message-ID: <BANLkTi=WU6h_0jOVL=_VwJawZd4qVnU-EA@mail.gmail.com>
Subject: signalfd() question - interaction with threads
From: Colin Walters <walters@verbum.org>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So in a bit of spare time I have been trying to make GLib use some
more modern Linux features, in particular signalfd().  The quick link
for that is here:
https://bugzilla.gnome.org/show_bug.cgi?id=652072

But I ran into a problem - I don't necessarily control all of the
threads in the process, and if any one of them has the signal
unblocked, it will be handled according to its default disposition
there instead of where I want - in the signalfd.

The signalfd example in the man page explicitly documents that you
need to sigprocmask(SIG_BLOCK), which is fine if you control all the
threads in your app, but I don't.  Any chance of a new flag like
SFD_HANDLE or SFD_ALWAYS which was rougly equivalent to using
sigaction()?  Or even better as I say in the bug, *always* deliver the
signal so I can get an event when a child exits even in the case where
some other code uses sigaction(SIGCHLD)?
