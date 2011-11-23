Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1KWOh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:37:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40664 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454Ab1KWOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:37:56 -0500
Date: Wed, 23 Nov 2011 14:39:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Xi Wang <xi.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ax25: integer overflows in ax25_setsockopt()
Message-ID: <20111123143913.50fbcc8c@lxorguk.ukuu.org.uk>
In-Reply-To: <CAKU6vyY3WjVwTK5Tcp2W93DefjJMreZjhtudNHBALns=6bK9Jw@mail.gmail.com>
References: <7187C142-99F1-4A96-9BE6-650B10C9B22D@gmail.com>
	<20111123104449.5e845a0f@lxorguk.ukuu.org.uk>
	<CAKU6vyY3WjVwTK5Tcp2W93DefjJMreZjhtudNHBALns=6bK9Jw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 09:04:11 -0500
Xi Wang <xi.wang@gmail.com> wrote:

> All these magic numbers come from net/ax25/sysctl_net_ax25.c, where
> min/max values of each field are set for sysctl.  Is it okay to use
> them?

The sysctl range is the 'standard' range, but it's always historically
been possible to override them in apps for special cases. I'm wary of
changing that because people do insane things like AX.25 bounced off the
moon where you need very long timeouts.

Alan
