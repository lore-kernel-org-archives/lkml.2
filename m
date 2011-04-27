Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab1D0Jqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:46:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39923 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756443Ab1D0Jqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:46:31 -0400
Date: Wed, 27 Apr 2011 10:47:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Lifeng Sun <lifongsun@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Applying inappropriate ioctl operation on socket should
 return ENOTTY
Message-ID: <20110427104738.2bdbe228@lxorguk.ukuu.org.uk>
In-Reply-To: <1303883910.2699.53.camel@edumazet-laptop>
References: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
	<1303883910.2699.53.camel@edumazet-laptop>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> EINVAL is ok too : Request or argp is not valid.

It confuses portable code in some situations
 
> I would say, its not a bug as you claim. 

POSIX and SuS tend to disagree

> Its really too late to make such change and risk regressions.

We've been quietly doing it for hundreds of cases including the entire
tty driver. Almost nobody (you included) has actually noticed and in
doing so we fixed various porting funnies without any reported
regressions.

Networking may be a more tricky one (not that tty wasn't a large one we
fixed) but most of the other driver ones are clearly sensible.

Alan
