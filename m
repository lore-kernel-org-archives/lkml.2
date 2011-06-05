Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1FETMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 15:12:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53407 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756004Ab1FETMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 15:12:42 -0400
Date: Sun, 5 Jun 2011 20:14:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com
Subject: Re: [PATCH 1/5] staging: et131x: et1310_address_map.h checkpatch
 fixes
Message-ID: <20110605201426.15570403@lxorguk.ukuu.org.uk>
In-Reply-To: <1307295320-31716-2-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
	<1307295320-31716-2-git-send-email-mark.einon@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +union RXMAC_WOL_SA_LO_t {
>  	u32 value;
>  	struct {
>  #ifdef _BIT_FIELDS_HTOL
> @@ -716,13 +716,13 @@ typedef union _RXMAC_WOL_SA_LO_t {
>  		u32 sa3:8;	/* bits 24-31 */

Pleease don't do it this way. If you look at the code we've been
systematically working through the unions turning them into definitions
in comments and sometimes bitmasks because almost none of the bit field
stuff is useful in these things anyway. Removing the typedefs without
doing it just muddles up what has and hasn't been done.

In fact in many cases the .value bit is the only bit used

Please keep to that style of describing the bits and knocking out fields
where it doesn't make sense.



