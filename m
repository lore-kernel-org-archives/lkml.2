Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3ACNFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:05:25 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36226 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3ACNFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:05:23 -0500
Date: Thu, 3 Jan 2013 13:11:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel J Blueman <daniel@quora.org>
Cc: Peter Jones <pjones@redhat.com>, linux-fbdev@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 3.8-rc2: EFI framebuffer lock inversion...
Message-ID: <20130103131156.214bd7a5@pyramind.ukuu.org.uk>
In-Reply-To: <CAMVG2ssA-B6s+F-g4mL0dbBSVsNupzT1nm1Kc70dXHGsNQuNYA@mail.gmail.com>
References: <CAMVG2ssA-B6s+F-g4mL0dbBSVsNupzT1nm1Kc70dXHGsNQuNYA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2013 20:56:30 +0800
Daniel J Blueman <daniel@quora.org> wrote:

> On 3.8-rc2 with lockdep enabled and dual-GPU setup (Macbook Pro
> Retina), I see two releated lock inversion issues with the EFI
> framebuffer, leading to possible deadlock: when X takes over from the
> EFI framebuffer [1] and when nouveau releases the framebuffer when
> being vgaswitcherood [2].
> 
> Let me know if you'd like any testing or analysis when I can get the time.

The fb layer locking was broken. I posted patches early December which
should have fixed the ones we know about. ('fb: Rework locking to fix
lock ordering on takeover').

Alan
