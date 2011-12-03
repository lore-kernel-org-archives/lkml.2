Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab1LCQlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 11:41:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42724 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232Ab1LCQlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 11:41:16 -0500
Date: Sat, 3 Dec 2011 16:42:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: HoP <jpetrous@gmail.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111203164252.3a66d638@lxorguk.ukuu.org.uk>
In-Reply-To: <4EDA4AB4.90303@linuxtv.org>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
	<4ED6C5B8.8040803@linuxtv.org>
	<4ED75F53.30709@redhat.com>
	<CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com>
	<20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<4EDA4AB4.90303@linuxtv.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW, the virtual DVB device we're talking about doesn't have any
> networking capabilities by itself. It only allows to create virtual DVB
> adapters and to relay DVB API ioctls to userspace in a
> transport-agnostic way.

Which you can do working from CUSE already, as has been pointed out or
with LD_PRELOAD. This btw makes the proprietary thing seem a rather odd
objection - they could do it too.

> The original version of the vtuner interface makes use of demux hardware
> and also feeds the relevant streams to a/v decoders, in which case you
> cannot avoid copying the MPEG data to kernel space.

Right and that aspect of it actually makes a lot more sense to me,
because receive and decode/playback are different functional units.

But jumping up and down arguing about how you want to name the code isn't
going to produce a productive result

To answer the other question posed by "HoP" - yes you can do TCP from
kernel space. We need this for things like NFS, CIFS etc. That might well
be valuable especially for low end hardware. The best code to read is
probably the net/sunrpc code to get an idea of how it ends up looking.

Alan
