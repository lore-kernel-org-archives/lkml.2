Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031067Ab2CAOGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:06:36 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42127 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031001Ab2CAOGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:06:35 -0500
Date: Thu, 1 Mar 2012 14:07:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/4] x86: add NO_IRQ macro
Message-ID: <20120301140753.5c44e27e@pyramind.ukuu.org.uk>
In-Reply-To: <6bda7538144dce0bf5780df3d0601147dae753b5.1330607068.git.rubini@gnudd.com>
References: <cover.1330607068.git.rubini@gnudd.com>
	<6bda7538144dce0bf5780df3d0601147dae753b5.1330607068.git.rubini@gnudd.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012 14:28:36 +0100
Alessandro Rubini <rubini@gnudd.com> wrote:

> This is needed to compile AMBA drivers. Most architectures define
> NO_IRQ as -1, and this does the same for the PC.

NAK

"No IRQ" is 0. There are a few platforms which incorrectly still define it
as -1 but they are broken and in fact many drivers won't work with
platforms that still incorrectly use -1. Nothing should be using a
NO_IRQ define.

Fix the users.


Alan
