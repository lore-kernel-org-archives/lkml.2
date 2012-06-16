Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2FPWbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 18:31:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60876 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab2FPWbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 18:31:45 -0400
Date: Sat, 16 Jun 2012 23:35:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-serial@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 04/10] fblog: implement fblog_redraw()
Message-ID: <20120616233526.7f830890@pyramind.ukuu.org.uk>
In-Reply-To: <1339884266-9201-5-git-send-email-dh.herrmann@googlemail.com>
References: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
	<1339884266-9201-5-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2012 00:04:20 +0200
David Herrmann <dh.herrmann@googlemail.com> wrote:

> This mostly copies the functionality from drivers/video/console/bitblit.c
> so we can draw the console content on all available framebuffers.
> 
> All speed optimizations have been removed for simplicity. The original
> code depends heavily on CONFIG_VT so we cannot share the codebase here.

No. That means we've got two sets of code to maintain not one. Fix the
dependancy.

Pull the relevant subset of struct vc_data into another struct
Make struct vc_data be

struct vc_data {
	struct vc_whatever
	rest
}

Alan
