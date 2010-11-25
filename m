Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0KYSHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 13:07:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52512 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751823Ab0KYSHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 13:07:36 -0500
Date: Thu, 25 Nov 2010 18:06:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Clemens Ladisch <clemens@ladisch.de>, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
Subject: Re: [RFC/PATCH v6 02/12] media: Media device
Message-ID: <20101125180627.16aa89c0@lxorguk.ukuu.org.uk>
In-Reply-To: <1q7hf5w7lvslx3nba6ooh9j2.1290705631030@email.android.com>
References: <1q7hf5w7lvslx3nba6ooh9j2.1290705631030@email.android.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Nov 2010 12:20:31 -0500
Andy Walls <awalls@md.metrocast.net> wrote:

> The signedness of char is ambiguous for 8 bit data, which is why an API would normally use u8 (or s8, I guess).
> 
> Since this is known to be character data, I would think char would be fine.  I am assuming C compilers would never assume multibyte "char"s.

char is 8bit in all modern C. I have used C compilers with configurable 9
or 7 bit char and such a machine is never going to run Linux without
serious insanity. Even grep in 9bit char is not fun...

The advantage of using u8 is that any casting goes the way you expect
whereas when working with UTF-8 things like

	int x = name[0];

may not produce the expected result otherwise.

Alan
