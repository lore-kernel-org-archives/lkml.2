Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0KDPrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:47:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51191 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431Ab0KDPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:47:06 -0400
Date: Thu, 4 Nov 2010 15:45:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gregory Giguashvili <Gregory.Giguashvili@PDGM.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Change signal mask after vfork/clone system call
Message-ID: <20101104154543.2a71cff1@lxorguk.ukuu.org.uk>
In-Reply-To: <DAF636D3923A51488784A1F985996EE804206DDF@exil1.paradigmgeo.net>
References: <DAF636D3923A51488784A1F985996EE803FCB7B0@exil1.paradigmgeo.net>
	<DAF636D3923A51488784A1F985996EE8041FAA46@exil1.paradigmgeo.net>
	<20101104094817.21548963@lxorguk.ukuu.org.uk>
	<DAF636D3923A51488784A1F985996EE804206DDF@exil1.paradigmgeo.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010 15:37:05 +0000
Gregory Giguashvili <Gregory.Giguashvili@PDGM.com> wrote:

> > Fork on pretty much any Unix like system around today does copy-on-write
> >so while not as efficient as vfork should be fine for most purposes.
> Yes, but the problem is that fork simply does not work when a process has huge resident size and vm.overcommit_memory=0 as preferred by Linux distributions we run on. So, processes with large RSS footprint may occasionally fail fork, even if a tiny process is to be started.
> 
> Using vfork always works, but has the signal mask problem. Catch 22?

And is there a reason you can't mask the signals, vfork and unmask them
again after the parent continues ?
