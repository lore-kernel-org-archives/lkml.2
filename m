Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910Ab2AKTRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:17:07 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:25167 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933615Ab2AKTRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:17:03 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UM6.7bIVM1kseKh6BaEwiVluFm.v8cdiITySPiQFp1uwB0C
 8iDzYyyg9MjXTD9K3tDB4NfvqaM8ImaozmIJLcxDFLaqW2Bc8TCa222sVHIe
 zmHFcP54dpwGkL8JeDODsYobN2WeBH1N50hEUAFDa9a1_gEg2hA6ioO2edb8
 RnYjcbPwkBX18u0uIa4RU.rCXFXmUakKicbeYHi9ek0PFpeyAcD2MqHgW4Nt
 iWwDvIUGfXZucJLeUE2qDKDpOGGptpo97YG6weAZiniX5y0oraZcKuIIQNnK
 8wfPF4XhErfcrPPyFkwNq6euF8mQwTty658_OrGksaywVBgEbzCEUINv7gPx
 N_LO7c.OD3UVLlyxfEixUPa5fYaCyh.qdNKiM6N2Tys1jAUpHJ1r0IpG4sFb
 lbacxxE0LDxw_zfrLsS2Cog--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 11 Jan 2012 13:17:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: John Stoffel <john@stoffel.org>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm] make swapin readahead skip over holes
In-Reply-To: <20237.39051.575883.450826@quad.stoffel.home>
Message-ID: <alpine.DEB.2.00.1201111305440.31239@router.home>
References: <20120109181023.7c81d0be@annuminas.surriel.com> <4F0B7D1F.7040802@gmail.com> <4F0BABE0.8080107@redhat.com> <CAHGf_=qtpA5VTw5W0zaAhB2WCX1+-k59szTnDLnqDJeg+q9Jsw@mail.gmail.com> <CAHGf_=odfZxYS+PcMfeJ2ddFm76+-KbOLNrjGBtoEdExdQmL3Q@mail.gmail.com>
 <20237.39051.575883.450826@quad.stoffel.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012, John Stoffel wrote:

> KOSAKI> so, we can eat free lunch up to 7MB ~= 60(MB/sec) * 1000 / 8.5(ms).
>
> What if the disk is busy doing other writeout or readin during this
> time?  You can't assume you have the full disk bandwidth available,
> esp when you hit a swap storm like this.

The assumptions by Kosaki are quite conservative.

What if one did not get a disk from the garbage heap but instead has a
state of the art storage cluster or simply an SSD (in particular relevant
now since HDs are in short supply given the situation in Asia)?

