Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883Ab2DJO0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:26:10 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41976 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876Ab2DJO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:26:07 -0400
Date: Tue, 10 Apr 2012 15:28:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wang YanQing <udknight@gmail.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, spock@gentoo.org
Subject: Re: [PATCH] video:uvesafb: Fix oops that uvesafb try to execute
 NX-protected page
Message-ID: <20120410152827.3fd489f6@pyramind.ukuu.org.uk>
In-Reply-To: <20120410064918.GA7611@udknight>
References: <20120327100136.GA3829@udknight>
	<20120327143243.015ecff6@pyramind.ukuu.org.uk>
	<20120328005238.GA3844@udknight>
	<20120401010530.GA4431@udknight>
	<20120410064918.GA7611@udknight>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Alan, are you decided to not reply this any? 

I'm not aware of anythign that needs adding to this. Any logic about
whether PCI BIOS methods can be called belongs in the PCI layer, as does
the necessary logic for marking ROMs executable if asked by a driver.

uvesafb isn't the only user of PCI methods that may be affected and the
PCI layer is the place that should export the method to decide this.

That will also then work sanely cross platform - since in general on non
x86 boxes the method can simply return "no"

Alan
