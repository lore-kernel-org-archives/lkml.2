Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183Ab2KBXh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:37:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36978 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881Ab2KBXhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:37:54 -0400
Date: Fri, 2 Nov 2012 23:43:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 1/2] PM: make VT switching to the suspend console
 optional
Message-ID: <20121102234302.28b773a7@pyramind.ukuu.org.uk>
In-Reply-To: <1351892621-4840-2-git-send-email-jbarnes@virtuousgeek.org>
References: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org>
	<1351892621-4840-2-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2012 14:43:40 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> KMS drivers can potentially restore the display configuration without
> userspace help.  Such drivers can set a new global, pm_vt_switch, to
> false if they support this feature.  In that case, the PM layer won't VT
> switch to the suspend console at suspend time and then back to the
> original VT on resume, but rather leave things alone for a nicer looking
> suspend and resume sequence.

What if you are multi-head ? What are the locking rules for a suspend/kms
module unload race, what happens when you load/unload and hand over
multiple frame buffers ? What if you have vts split across two adapters ?

Put me down as 100% in favour of the feature but we need to be a bit more
careful about the implementation. The logic probably needs to be in the
vt layer.

I suspect we actually need a per vt flag for this, or a flag on the
underlying object below the vt somewhere.

So NAK for the implementation ACK for the idea.

Alan
